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
