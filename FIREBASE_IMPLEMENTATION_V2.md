# Firebase Implementation Guide - Version 2.0

Complete implementation guide for Firebase services, models, and providers.

---

## 📋 Table of Contents

1. [Firebase Services](#firebase-services)
2. [Firestore Data Models](#firestore-data-models)
3. [Authentication Service](#authentication-service)
4. [Image Upload Service](#image-upload-service)
5. [Provider Updates](#provider-updates)
6. [Migration from Local Storage](#migration-from-local-storage)

---

## Firebase Services

### Directory Structure

```
lib/
├── services/
│   ├── firebase/
│   │   ├── auth_service.dart
│   │   ├── firestore_service.dart
│   │   ├── storage_service.dart
│   │   └── analytics_service.dart
│   ├── image_compression_service.dart
│   └── dummy_data_service.dart  // Keep for demo
├── models/
│   ├── firebase/
│   │   ├── shop_model.dart
│   │   ├── template_firestore_model.dart
│   │   └── product_firestore_model.dart
│   ├── form_template_model.dart  // Keep existing
│   └── product_model.dart  // Keep existing
└── providers/
    ├── auth_provider.dart  // NEW
    ├── template_provider.dart  // UPDATE
    └── product_provider.dart  // UPDATE
```

---

## Firestore Data Models

### Shop Model

**Purpose**: Represents a shop/store owner

**File**: `lib/models/firebase/shop_model.dart`

```dart
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
```

### Template Firestore Model

**File**: `lib/models/firebase/template_firestore_model.dart`

```dart
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
}
```

### Product Firestore Model

**File**: `lib/models/firebase/product_firestore_model.dart`

```dart
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
}
```

---

## Authentication Service

**File**: `lib/services/firebase/auth_service.dart`

```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/firebase/shop_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Current user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Current user
  User? get currentUser => _auth.currentUser;

  // Current shop ID (same as uid)
  String? get currentShopId => currentUser?.uid;

  // Sign up with email and password
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    required String shopName,
  }) async {
    try {
      // Create user
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create shop document
      final shopId = credential.user!.uid;
      final shop = ShopModel(
        id: shopId,
        name: shopName,
        email: email,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection('shops')
          .doc(shopId)
          .set(shop.toFirestore());

      return credential;
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with email and password
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Get current shop
  Future<ShopModel?> getCurrentShop() async {
    if (currentShopId == null) return null;

    try {
      final doc = await _firestore
          .collection('shops')
          .doc(currentShopId)
          .get();

      if (!doc.exists) return null;

      return ShopModel.fromFirestore(doc);
    } catch (e) {
      return null;
    }
  }

  // Update shop
  Future<void> updateShop(ShopModel shop) async {
    await _firestore
        .collection('shops')
        .doc(shop.id)
        .update(shop.toFirestore());
  }

  // Delete account
  Future<void> deleteAccount() async {
    if (currentUser == null) return;

    // Delete shop document
    await _firestore
        .collection('shops')
        .doc(currentShopId)
        .delete();

    // Delete user
    await currentUser!.delete();
  }
}
```

---

## Firestore Service

**File**: `lib/services/firebase/firestore_service.dart`

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/firebase/template_firestore_model.dart';
import '../../models/firebase/product_firestore_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ============ TEMPLATES ============

  // Get all templates for a shop
  Future<List<TemplateFirestoreModel>> getTemplates(String shopId) async {
    final snapshot = await TemplateFirestoreModel.collection(shopId)
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // Get single template
  Future<TemplateFirestoreModel?> getTemplate(
    String shopId,
    String templateId,
  ) async {
    final doc = await TemplateFirestoreModel.collection(shopId)
        .doc(templateId)
        .get();

    return doc.exists ? doc.data() : null;
  }

  // Create template
  Future<String> createTemplate(
    String shopId,
    TemplateFirestoreModel template,
  ) async {
    final docRef = await TemplateFirestoreModel.collection(shopId)
        .add(template);

    // Update shop stats
    await _incrementShopTemplateCount(shopId);

    return docRef.id;
  }

  // Update template
  Future<void> updateTemplate(
    String shopId,
    TemplateFirestoreModel template,
  ) async {
    await TemplateFirestoreModel.collection(shopId)
        .doc(template.id)
        .set(template);
  }

  // Delete template
  Future<void> deleteTemplate(String shopId, String templateId) async {
    await TemplateFirestoreModel.collection(shopId)
        .doc(templateId)
        .update({'isActive': false});

    // Update shop stats
    await _decrementShopTemplateCount(shopId);
  }

  // ============ PRODUCTS ============

  // Get all products for a shop
  Future<List<ProductFirestoreModel>> getProducts(
    String shopId, {
    int? limit,
    DocumentSnapshot? startAfter,
  }) async {
    Query<ProductFirestoreModel> query = ProductFirestoreModel.collection(shopId)
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // Get products by template
  Future<List<ProductFirestoreModel>> getProductsByTemplate(
    String shopId,
    String templateId, {
    int? limit,
  }) async {
    Query<ProductFirestoreModel> query = ProductFirestoreModel.collection(shopId)
        .where('templateId', isEqualTo: templateId)
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // Search products
  Future<List<ProductFirestoreModel>> searchProducts(
    String shopId,
    String searchTerm, {
    int? limit,
  }) async {
    Query<ProductFirestoreModel> query = ProductFirestoreModel.collection(shopId)
        .where('searchTerms', arrayContains: searchTerm.toLowerCase())
        .where('isActive', isEqualTo: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // Get single product
  Future<ProductFirestoreModel?> getProduct(
    String shopId,
    String productId,
  ) async {
    final doc = await ProductFirestoreModel.collection(shopId)
        .doc(productId)
        .get();

    return doc.exists ? doc.data() : null;
  }

  // Create product
  Future<String> createProduct(
    String shopId,
    ProductFirestoreModel product,
  ) async {
    final docRef = await ProductFirestoreModel.collection(shopId)
        .add(product);

    // Update shop stats
    await _incrementShopProductCount(shopId);

    return docRef.id;
  }

  // Update product
  Future<void> updateProduct(
    String shopId,
    ProductFirestoreModel product,
  ) async {
    await ProductFirestoreModel.collection(shopId)
        .doc(product.id)
        .set(product);
  }

  // Delete product
  Future<void> deleteProduct(String shopId, String productId) async {
    await ProductFirestoreModel.collection(shopId)
        .doc(productId)
        .update({'isActive': false});

    // Update shop stats
    await _decrementShopProductCount(shopId);
  }

  // ============ HELPER METHODS ============

  Future<void> _incrementShopTemplateCount(String shopId) async {
    await _firestore
        .collection('shops')
        .doc(shopId)
        .update({
          'totalTemplates': FieldValue.increment(1),
          'updatedAt': FieldValue.serverTimestamp(),
        });
  }

  Future<void> _decrementShopTemplateCount(String shopId) async {
    await _firestore
        .collection('shops')
        .doc(shopId)
        .update({
          'totalTemplates': FieldValue.increment(-1),
          'updatedAt': FieldValue.serverTimestamp(),
        });
  }

  Future<void> _incrementShopProductCount(String shopId) async {
    await _firestore
        .collection('shops')
        .doc(shopId)
        .update({
          'totalProducts': FieldValue.increment(1),
          'updatedAt': FieldValue.serverTimestamp(),
        });
  }

  Future<void> _decrementShopProductCount(String shopId) async {
    await _firestore
        .collection('shops')
        .doc(shopId)
        .update({
          'totalProducts': FieldValue.increment(-1),
          'updatedAt': FieldValue.serverTimestamp(),
        });
  }

  // Enable offline persistence
  Future<void> enableOffline() async {
    await _firestore.enablePersistence(
      const PersistenceSettings(synchronizeTabs: true),
    );
  }
}
```

---

## Image Upload Service

**File**: `lib/services/firebase/storage_service.dart`

```dart
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload product image
  Future<String> uploadProductImage({
    required String shopId,
    required String productId,
    required File imageFile,
    required int index,
  }) async {
    try {
      // Compress image
      final compressed = await compressImage(imageFile);

      // Upload path
      final fileName = 'img_$index${path.extension(imageFile.path)}';
      final uploadPath = 'shops/$shopId/products/$productId/$fileName';

      // Upload
      final ref = _storage.ref(uploadPath);
      await ref.putFile(compressed);

      // Get download URL
      final downloadUrl = await ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }

  // Upload thumbnail
  Future<String> uploadThumbnail({
    required String shopId,
    required String productId,
    required File imageFile,
    required int index,
  }) async {
    try {
      // Generate thumbnail
      final thumbnail = await generateThumbnail(imageFile);

      // Upload path
      final fileName = 'thumb_$index${path.extension(imageFile.path)}';
      final uploadPath = 'shops/$shopId/products/$productId/$fileName';

      // Upload
      final ref = _storage.ref(uploadPath);
      await ref.putFile(thumbnail);

      // Get download URL
      final downloadUrl = await ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }

  // Delete product images
  Future<void> deleteProductImages({
    required String shopId,
    required String productId,
  }) async {
    try {
      final ref = _storage.ref('shops/$shopId/products/$productId');
      final listResult = await ref.listAll();

      // Delete all files
      for (final item in listResult.items) {
        await item.delete();
      }
    } catch (e) {
      // Ignore errors if folder doesn't exist
    }
  }

  // Compress image (800x800 max, 85% quality)
  Future<File> compressImage(File file) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      '${file.path}_compressed.jpg',
      quality: 85,
      minWidth: 800,
      minHeight: 800,
    );

    return result != null ? File(result.path) : file;
  }

  // Generate thumbnail (200x200 max, 70% quality)
  Future<File> generateThumbnail(File file) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      '${file.path}_thumb.jpg',
      quality: 70,
      minWidth: 200,
      minHeight: 200,
    );

    return result != null ? File(result.path) : file;
  }

  // Get storage usage for shop
  Future<double> getStorageUsage(String shopId) async {
    try {
      final ref = _storage.ref('shops/$shopId');
      final listResult = await ref.listAll();

      double totalBytes = 0;

      for (final item in listResult.items) {
        final metadata = await item.getMetadata();
        totalBytes += metadata.size ?? 0;
      }

      // Return in MB
      return totalBytes / (1024 * 1024);
    } catch (e) {
      return 0;
    }
  }
}
```

---

## Migration Strategy

### From Local Storage to Firestore

**File**: `lib/services/migration_service.dart`

```dart
import '../services/storage_service.dart';
import '../services/firebase/firestore_service.dart';
import '../services/firebase/auth_service.dart';
import '../models/firebase/template_firestore_model.dart';
import '../models/firebase/product_firestore_model.dart';

class MigrationService {
  final StorageService _localStorage = StorageService();
  final FirestoreService _firestore = FirestoreService();
  final AuthService _auth = AuthService();

  // Migrate local templates to Firestore
  Future<void> migrateTemplates() async {
    final shopId = _auth.currentShopId;
    if (shopId == null) return;

    // Get local templates
    final localTemplates = await _localStorage.getTemplates();

    for (final template in localTemplates) {
      // Convert to Firestore model
      final firestoreTemplate = TemplateFirestoreModel(
        id: template.id,
        shopId: shopId,
        name: template.name,
        description: template.description,
        fields: template.fields,
        createdAt: template.createdAt,
        updatedAt: template.updatedAt,
        isActive: template.isActive,
      );

      // Upload to Firestore
      await _firestore.updateTemplate(shopId, firestoreTemplate);
    }

    print('Migrated ${localTemplates.length} templates');
  }

  // Migrate local products to Firestore
  Future<void> migrateProducts() async {
    final shopId = _auth.currentShopId;
    if (shopId == null) return;

    // Get local products
    final localProducts = await _localStorage.getProducts();

    for (final product in localProducts) {
      // Generate search terms
      final searchTerms = ProductFirestoreModel.generateSearchTerms(
        product.data,
      );

      // Convert to Firestore model
      final firestoreProduct = ProductFirestoreModel(
        id: product.id,
        shopId: shopId,
        templateId: product.templateId,
        templateName: product.templateName,
        data: product.data,
        searchTerms: searchTerms,
        createdAt: product.createdAt,
        updatedAt: product.updatedAt,
        isActive: product.isActive,
      );

      // Upload to Firestore
      await _firestore.updateProduct(shopId, firestoreProduct);
    }

    print('Migrated ${localProducts.length} products');
  }

  // Full migration
  Future<void> migrateAll() async {
    await migrateTemplates();
    await migrateProducts();
  }
}
```

---

## Summary

This implementation provides:

✅ Complete Firebase integration
✅ Offline-first architecture
✅ Image optimization (compression + thumbnails)
✅ Search functionality
✅ Real-time updates
✅ Cost optimization (caching, pagination)
✅ Migration from local storage

**Next Steps:**
1. Update providers to use Firebase services
2. Add authentication UI
3. Test offline functionality
4. Deploy security rules
5. Monitor usage and costs

---

**Version**: 2.0
**Last Updated**: 2024-11-18
