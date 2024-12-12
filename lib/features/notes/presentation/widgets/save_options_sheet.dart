import 'package:flutter/material.dart';

class ImageOptionsSheet extends StatelessWidget {
  final VoidCallback onPickImage;
  final VoidCallback onDeleteImage;

  const ImageOptionsSheet({
    super.key,
    required this.onPickImage,
    required this.onDeleteImage,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      color: theme.cardColor,
      height: 150,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Pick Another Image'),
            onTap: () {
              Navigator.pop(context);
              onPickImage();
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete Image'),
            onTap: onDeleteImage,
          ),
        ],
      ),
    );
  }
}
