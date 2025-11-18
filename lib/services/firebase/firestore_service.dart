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
