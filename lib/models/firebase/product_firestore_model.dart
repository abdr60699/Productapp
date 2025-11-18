import 'package:cloud_firestore/cloud_firestore.dart';

class ProductFirestoreModel {
  final String id;
  final String shopId;
  final String templateId;
  final String templateName;
  final Map<String, dynamic> data;
  final List<String> searchTerms; // For search
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  ProductFirestoreModel({
    required this.id,
    required this.shopId,
    required this.templateId,
    required this.templateName,
    required this.data,
    required this.searchTerms,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
  });

  // From Firestore
  factory ProductFirestoreModel.fromFirestore(
    String shopId,
    DocumentSnapshot doc,
  ) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductFirestoreModel(
      id: doc.id,
      shopId: shopId,
      templateId: data['templateId'] ?? '',
      templateName: data['templateName'] ?? '',
      data: Map<String, dynamic>.from(data['data'] ?? {}),
      searchTerms: List<String>.from(data['searchTerms'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      isActive: data['isActive'] ?? true,
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'templateId': templateId,
      'templateName': templateName,
      'data': data,
      'searchTerms': searchTerms,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isActive': isActive,
    };
  }

  // Generate search terms from product data
  static List<String> generateSearchTerms(Map<String, dynamic> data) {
    final terms = <String>{};

    data.forEach((key, value) {
      if (value == null) return;

      if (value is String) {
        // Split by spaces and add each word
        terms.addAll(
          value.toLowerCase().split(RegExp(r'\s+')),
        );
      } else if (value is List) {
        // Add each item in list
        for (var item in value) {
          if (item is String) {
            terms.add(item.toLowerCase());
          }
        }
      } else {
        // Add string representation
        terms.add(value.toString().toLowerCase());
      }
    });

    // Remove empty strings and short terms
    return terms.where((term) => term.length >= 2).toList();
  }

  // Get display name from data
  String get displayName {
    // Try common field names
    final nameFields = ['product_name', 'name', 'title', 'dish_name'];

    for (final field in nameFields) {
      if (data.containsKey(field) && data[field] != null) {
        return data[field].toString();
      }
    }

    // Fallback to first non-empty string value
    for (final value in data.values) {
      if (value is String && value.isNotEmpty) {
        return value;
      }
    }

    return 'Unnamed Product';
  }

  // Collection reference for this shop
  static CollectionReference<ProductFirestoreModel> collection(
    String shopId,
  ) {
    return FirebaseFirestore.instance
        .collection('shops')
        .doc(shopId)
        .collection('products')
        .withConverter<ProductFirestoreModel>(
          fromFirestore: (snapshot, _) =>
              ProductFirestoreModel.fromFirestore(shopId, snapshot),
          toFirestore: (product, _) => product.toFirestore(),
        );
  }

  ProductFirestoreModel copyWith({
    String? templateId,
    String? templateName,
    Map<String, dynamic>? data,
    List<String>? searchTerms,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return ProductFirestoreModel(
      id: id,
      shopId: shopId,
      templateId: templateId ?? this.templateId,
      templateName: templateName ?? this.templateName,
      data: data ?? this.data,
      searchTerms: searchTerms ?? this.searchTerms,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
