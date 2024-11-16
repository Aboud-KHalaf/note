import 'package:flutter/material.dart';
import 'package:note/core/helpers/colors/app_colors.dart';

class NotesFolderItem extends StatelessWidget {
  const NotesFolderItem({
    super.key,
    required this.folder,
    required this.colorIdx,
  });

  final String folder;
  final int colorIdx;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: AppColors.background,
            blurRadius: 16.0,
            blurStyle: BlurStyle.outer,
          ),
        ],
        border: Border.all(color: Colors.white),
        color: AppColors.cardColors[colorIdx],
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
