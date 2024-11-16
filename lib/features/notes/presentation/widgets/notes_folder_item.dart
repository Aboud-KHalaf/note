import 'package:flutter/material.dart';
import 'package:note/core/helpers/colors/app_colors.dart';

class NotesFolderItem extends StatelessWidget {
  const NotesFolderItem({
    super.key,
    required this.folder,
  });

  final String folder;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 5.0,
          ),
        ],
        color: AppColors.primary.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          folder,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
