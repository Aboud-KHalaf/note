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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            colorFilter: ColorFilter.mode(
                AppColors.cardColors[folder.color], BlendMode.srcIn),
            SvgProvider.folder,
            width: 100,
          ),
          Text(folder.name),
        ],
      ),
    );
  }
}
