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
