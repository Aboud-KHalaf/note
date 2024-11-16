import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  /// Picks an image from the gallery
  Future<File?> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  /// Picks an image from the camera
  Future<File?> pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  /// Picks a video from the gallery
  Future<File?> pickVideoFromGallery() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      return File(video.path);
    }
    return null;
  }

  /// Picks a video from the camera
  Future<File?> pickVideoFromCamera() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
    if (video != null) {
      return File(video.path);
    }
    return null;
  }

  Future<File?> pickImage(ImageSource source) async {
    if (source == ImageSource.gallery) {
      return pickImageFromGallery();
    } else {
      return pickImageFromCamera();
    }
  }
}
