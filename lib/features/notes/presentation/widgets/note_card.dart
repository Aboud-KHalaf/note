import 'dart:io';
import 'package:flutter/material.dart';
import 'package:note/core/helpers/colors/app_colors.dart';
import 'package:note/core/helpers/functions/ui_functions.dart';
import 'package:note/core/helpers/styles/spacing_h.dart';
import 'package:note/features/notes/domain/entities/note_entity.dart';
import 'package:note/features/notes/presentation/widgets/image_display.dart';
import 'package:note/features/notes/presentation/widgets/markdown_content.dart';
import 'package:note/features/notes/presentation/widgets/notes_folder_list_view.dart';
import 'package:flutter_animate/flutter_animate.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.cardColor,
    required this.note,
    required this.isSelected,
    this.index = 0,
  });

  final Color cardColor;
  final bool isSelected;
  final NoteEntity note;
  final int index;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12.0),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      decoration: BoxDecoration(
        color: isSelected
            ? theme.primaryColor.withOpacity(0.5)
            : (note.color <= 1)
                ? theme.cardColor
                : AppColors.cardColors[note.color],
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: isSelected ? Colors.white : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (note.imageUrl != '' && note.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: ImageDisplay(
                  image: File(note.imageUrl!),
                  onLongPress: () {},
                ),
              )
                  .animate()
                  .fade(duration: const Duration(milliseconds: 300))
                  .scale(delay: Duration(milliseconds: index * 50)),
            SpacingHelper.h2,
            Flexible(
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  note.title,
                  textDirection: isArbic(note.title[0])
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: theme.textTheme.titleLarge?.color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
                .animate()
                .fade(duration: const Duration(milliseconds: 300))
                .slideX(begin: 0.1, end: 0),
            const SizedBox(height: 8.0),
            Flexible(
              child: SizedBox(
                width: double.infinity,
                child: MarkdownContent(
                  content: note.content,
                  direction:
                      isArbic(note.content.isNotEmpty ? note.content[0] : 'a')
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                ),
              ),
            )
                .animate()
                .fade(duration: const Duration(milliseconds: 300))
                .slideX(
                    begin: 0.1,
                    end: 0,
                    delay: const Duration(milliseconds: 100)),
            const SizedBox(height: 8),
            NotesFolderListView(
              folders: note.folders,
              colorIdx: note.color,
            )
                .animate()
                .fade(duration: const Duration(milliseconds: 300))
                .slideX(
                    begin: 0.1,
                    end: 0,
                    delay: const Duration(milliseconds: 200)),
          ],
        ),
      ),
    )
        .animate()
        .fade(duration: const Duration(milliseconds: 300))
        .scale(delay: Duration(milliseconds: index * 50));
  }
}
