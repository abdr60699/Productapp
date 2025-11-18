// lib/src/file_utils.dart
import 'dart:io';
import 'package:mime/mime.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class FileUtils {
  FileUtils._();

  static String getFileName(String path) =>
      path.split(Platform.pathSeparator).last;

  static String getFileExtension(String path) {
    final name = getFileName(path);
    return name.contains('.') ? name.split('.').last : '';
  }

  static String? getMimeType(String path) => lookupMimeType(path);

  static Future<File?> pickImage({bool fromCamera = false}) async {
    final picked = await ImagePicker().pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    );
    return picked != null ? File(picked.path) : null;
  }

  static Future<File?> compressImage(
    File file, {
    int quality = 80,
  }) async {
    final target = file.path.replaceAll('.', '_compressed.');

    final XFile? compressed = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      target,
      quality: quality,
    );

    return compressed != null ? File(compressed.path) : null;
  }
}
