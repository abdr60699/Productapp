import 'package:cloud_firestore/cloud_firestore.dart';

class ShopModel {
  final String id; // Same as Firebase Auth uid
  final String name;
  final String? description;
  final String? email;
  final String? phone;
  final String? logoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  // Stats
  final int totalProducts;
  final int totalTemplates;
  final double storageUsedMB;

  ShopModel({
    required this.id,
    required this.name,
    this.description,
    this.email,
    this.phone,
    this.logoUrl,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.totalProducts = 0,
    this.totalTemplates = 0,
    this.storageUsedMB = 0.0,
  });

  // From Firestore
  factory ShopModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ShopModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'],
      email: data['email'],
      phone: data['phone'],
      logoUrl: data['logoUrl'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      isActive: data['isActive'] ?? true,
      totalProducts: data['totalProducts'] ?? 0,
      totalTemplates: data['totalTemplates'] ?? 0,
      storageUsedMB: (data['storageUsedMB'] ?? 0.0).toDouble(),
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'email': email,
      'phone': phone,
      'logoUrl': logoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isActive': isActive,
      'totalProducts': totalProducts,
      'totalTemplates': totalTemplates,
      'storageUsedMB': storageUsedMB,
    };
  }

  ShopModel copyWith({
    String? name,
    String? description,
    String? email,
    String? phone,
    String? logoUrl,
    DateTime? updatedAt,
    bool? isActive,
    int? totalProducts,
    int? totalTemplates,
    double? storageUsedMB,
  }) {
    return ShopModel(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      logoUrl: logoUrl ?? this.logoUrl,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      totalProducts: totalProducts ?? this.totalProducts,
      totalTemplates: totalTemplates ?? this.totalTemplates,
      storageUsedMB: storageUsedMB ?? this.storageUsedMB,
    );
  }
}
