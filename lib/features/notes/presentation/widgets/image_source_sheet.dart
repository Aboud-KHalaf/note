import 'package:flutter/material.dart';
import 'package:note/core/helpers/localization/app_localization.dart';

class ImageSourceSheet extends StatelessWidget {
  final VoidCallback onCameraPressed;
  final VoidCallback onGalleryPressed;

  const ImageSourceSheet({
    super.key,
    required this.onCameraPressed,
    required this.onGalleryPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.camera),
            title: Text('camera'.tr(context)),
            onTap: () {
              Navigator.of(context).pop();
              onCameraPressed();
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: Text('gallaery'.tr(context)),
            onTap: () {
              Navigator.of(context).pop();
              onGalleryPressed();
            },
          ),
        ],
      ),
    );
  }
}
