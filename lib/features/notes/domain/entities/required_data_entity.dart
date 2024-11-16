import 'dart:io';

class RequiredDataEntity {
  final String id;
  final String imageUrl;
  final File? image;
  final int color;
  final int? inSynced;
  final String userId;
  final String title;
  final String content;
  final List<String> folders;

  RequiredDataEntity({
    required this.imageUrl,
    this.color = 0,
    this.image,
    this.inSynced,
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.folders,
  });
}
