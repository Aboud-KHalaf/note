// /lib/shared/widgets/image_display.dart
import 'dart:io';
import 'package:flutter/material.dart';

class ImageDisplay extends StatelessWidget {
  final File image;
  final VoidCallback onLongPress;

  const ImageDisplay({
    super.key,
    required this.image,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          image,
          height: 200,
          width: double.infinity,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
