import 'dart:io';
import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  const ImageView({super.key, required this.image});
  static const String id = 'image view';

  final File image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.file(image),
      ),
    );
  }
}
