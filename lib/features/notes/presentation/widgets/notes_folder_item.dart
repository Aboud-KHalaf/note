import 'package:flutter/material.dart';
import 'package:note/core/helpers/colors/app_colors.dart';
import 'package:note/core/helpers/styles/fonts_h.dart';

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
    var theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.hintColor),
        color:
            (colorIdx <= 1 ? theme.cardColor : AppColors.cardColors[colorIdx]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          folder,
          style: FontsStylesHelper.textStyle10.copyWith(color: theme.hintColor),
        ),
      ),
    );
  }
}
