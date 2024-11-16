import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'package:note/core/utils/logger.dart';

class ImageService {
  // Private constructor
  ImageService._();

  // Singleton instance
  static final ImageService instance = ImageService._();

  // Factory constructor to return the same instance every time
  factory ImageService() => instance;

  Future<String> saveImage(File image, String id) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileExtension = path.extension(image.path);

    // Use the provided id to name the imageP
    final fileName = '$id$fileExtension';

    Log.info(id);
    // Check if an image with the same ID already exists
    final existingImage =
        await _findExistingImage(directory, id, fileExtension);
    if (existingImage != null) {
      return existingImage.path;
    }

    // If not found, save the new image
    final savedImage = await image.copy('${directory.path}/$fileName');
    Log.error(savedImage.path);
    return savedImage.path;
  }

  Future<File?> _findExistingImage(
      Directory directory, String id, String extension) async {
    final files = directory.listSync();
    for (var file in files) {
      if (file is File &&
          path.basename(file.path).startsWith(id) &&
          file.path.endsWith(extension)) {
        return file;
      }
    }
    return null;
  }

  Future<void> deleteImage(File image) async {
    if (await image.exists()) {
      await image.delete();
    }
  }

  Future<void> deleteImageFromPath(String imagePath) async {
    final file = File(imagePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<void> showAllImages() async {
    final directory = await getApplicationDocumentsDirectory();
    final contents = directory.listSync();
    var con = contents
        .whereType<File>()
        .where((file) => ['.jpg', '.jpeg', '.png', '.gif']
            .contains(path.extension(file.path).toLowerCase()))
        .map((file) => file.path)
        .toList();
    for (var image in con) {
      Log.cyan(image);
    }
  }
}
