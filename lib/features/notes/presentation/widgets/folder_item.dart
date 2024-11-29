import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:note/core/helpers/colors/app_colors.dart';
import 'package:note/core/helpers/providers/svg_provider.dart';
import 'package:note/features/folders/domain/entities/folder_entity.dart';

class FolderItem extends StatelessWidget {
  const FolderItem({
    super.key,
    required this.folder,
  });

  final FolderEntity folder;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors
                  .transparent, // Set to transparent or a background color if needed
              boxShadow: [
                BoxShadow(
                  color:
                      Colors.black.withOpacity(0.2), // Shadow color and opacity
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(4, 4), // Shadow position
                ),
              ],
            ),
            child: SvgPicture.asset(
              SvgProvider.folder,
              colorFilter: ColorFilter.mode(
                AppColors.cardColors[folder.color],
                BlendMode.srcIn,
              ),
              width: 100,
            ),
          ),
          Text(folder.name),
        ],
      ),
    );
  }
}
