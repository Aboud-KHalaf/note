import 'dart:typed_data';

class ImageEntity {
  final String id;
  final String noteId;
  final Uint8List imageData;
  ImageEntity({
    required this.id,
    required this.noteId,
    required this.imageData,
  });
}
