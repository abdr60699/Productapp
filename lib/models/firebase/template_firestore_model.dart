import 'package:cloud_firestore/cloud_firestore.dart';
import '../form_field_model.dart';

class TemplateFirestoreModel {
  final String id;
  final String shopId;
  final String name;
  final String description;
  final List<FormFieldModel> fields;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  TemplateFirestoreModel({
    required this.id,
    required this.shopId,
    required this.name,
    required this.description,
    required this.fields,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
  });

  // From Firestore
  factory TemplateFirestoreModel.fromFirestore(
    String shopId,
    DocumentSnapshot doc,
  ) {
    final data = doc.data() as Map<String, dynamic>;
    return TemplateFirestoreModel(
      id: doc.id,
      shopId: shopId,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      fields: (data['fields'] as List<dynamic>)
          .map((field) => FormFieldModel.fromJson(field))
          .toList(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      isActive: data['isActive'] ?? true,
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'fields': fields.map((field) => field.toJson()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isActive': isActive,
    };
  }

  // Collection reference for this shop
  static CollectionReference<TemplateFirestoreModel> collection(
    String shopId,
  ) {
    return FirebaseFirestore.instance
        .collection('shops')
        .doc(shopId)
        .collection('templates')
        .withConverter<TemplateFirestoreModel>(
          fromFirestore: (snapshot, _) =>
              TemplateFirestoreModel.fromFirestore(shopId, snapshot),
          toFirestore: (template, _) => template.toFirestore(),
        );
  }

  TemplateFirestoreModel copyWith({
    String? name,
    String? description,
    List<FormFieldModel>? fields,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return TemplateFirestoreModel(
      id: id,
      shopId: shopId,
      name: name ?? this.name,
      description: description ?? this.description,
      fields: fields ?? this.fields,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
