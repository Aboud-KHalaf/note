import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:note/core/helpers/colors/app_colors.dart';
import 'package:note/core/helpers/styles/fonts_h.dart';

class NotesFolderListView extends StatelessWidget {
  const NotesFolderListView({
    required this.folders,
    super.key,
    required this.colorIdx,
  });

  final List<String> folders;
  final int colorIdx;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredFolders = folders.where((f) => f.isNotEmpty).toList();

    if (filteredFolders.isEmpty) return const SizedBox();

    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filteredFolders.length,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: NotesFolderItem(
              colorIdx: colorIdx,
              folder: filteredFolders[index],
            ),
          ).animate().fade(duration: const Duration(milliseconds: 300)).slideX(
              begin: 0.2, end: 0, delay: Duration(milliseconds: index * 50));
        },
      ),
    );
  }
}

class NotesFolderItem extends StatelessWidget {
  const NotesFolderItem({
    super.key,
    required this.colorIdx,
    required this.folder,
  });

  final int colorIdx;
  final String folder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorIdx <= 1
            ? (isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.05))
            : AppColors.cardColors[colorIdx].withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorIdx <= 1
              ? theme.colorScheme.outline.withOpacity(0.2)
              : AppColors.cardColors[colorIdx].withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.folder,
            size: 14,
            color: colorIdx <= 1
                ? theme.colorScheme.onSurfaceVariant
                : Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            folder,
            style: FontsStylesHelper.textStyle12.copyWith(
              color: colorIdx <= 1
                  ? theme.colorScheme.onSurfaceVariant
                  : Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
