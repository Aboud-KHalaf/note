import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note/core/services/image_picker_service.dart';
import 'package:note/core/services/image_storage_services.dart';
import 'package:note/features/notes/domain/entities/note_entity.dart';
import 'package:note/features/notes/domain/entities/required_data_entity.dart';

class NoteDetailService {
  final ImagePickerService _imagePickerService;
  final ImageService _imageService;

  NoteDetailService({
    required ImagePickerService imagePickerService,
    required ImageService imageService,
  })  : _imagePickerService = imagePickerService,
        _imageService = imageService;

  Future<File?> pickImage(ImageSource source) async {
    return await _imagePickerService.pickImage(source);
  }

  Future<void> deleteImage(File image) async {
    await _imageService.deleteImage(image);
  }

  bool validateNote(String title, String content) {
    return title.trim().isNotEmpty || content.trim().isNotEmpty;
  }

  TextDirection detectTextDirection(String text) {
    if (text.isEmpty) return TextDirection.ltr;

    final firstChar = text.trim().characters.first;
    return _isArabic(firstChar) ? TextDirection.rtl : TextDirection.ltr;
  }

  bool _isArabic(String char) {
    // Implement your Arabic character detection logic
    // This is a simplified example
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(char);
  }

  RequiredDataEntity prepareNoteData({
    required NoteEntity? existingNote,
    required String userId,
    required String title,
    required String content,
    required File? image,
    required List<String> folders,
    required int color,
  }) {
    return RequiredDataEntity(
      imageUrl: existingNote?.imageUrl ?? '',
      color: color,
      id: existingNote?.id ?? '',
      userId: userId,
      title: title.trim(),
      content: content.trim(),
      image: image,
      folders: folders,
      inSynced: existingNote?.isSynced ?? 0,
    );
  }
}
