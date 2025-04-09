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
            ? theme.primaryColor.withOpacity(0.1)
            : (note.color <= 1)
                ? theme.cardColor
                : AppColors.cardColors[note.color],
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: isSelected ? theme.primaryColor : Colors.transparent,
          width: isSelected ? 2.5 : 0,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? theme.primaryColor.withOpacity(0.2)
                : Colors.black.withOpacity(0.1),
            blurRadius: isSelected ? 15.0 : 10.0,
            offset: const Offset(0, 4),
            spreadRadius: isSelected ? 2.0 : 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5 - 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (note.imageUrl != '' && note.imageUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Stack(
                        children: [
                          ImageDisplay(
                            image: File(note.imageUrl!),
                            onLongPress: () {},
                          ),
                          if (isSelected)
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    theme.primaryColor.withOpacity(0.3),
                                    theme.primaryColor.withOpacity(0.1),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: theme.primaryColor.withOpacity(0.9),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            theme.primaryColor.withOpacity(0.3),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: theme.colorScheme.onPrimary,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                        ],
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
                          color: isSelected
                              ? theme.primaryColor
                              : theme.textTheme.titleLarge?.color,
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
                        direction: isArbic(
                                note.content.isNotEmpty ? note.content[0] : 'a')
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
          ),
          if (isSelected)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: theme.primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.check,
                  color: theme.colorScheme.onPrimary,
                  size: 16,
                ),
              ),
            ),
        ],
      ),
    )
        .animate()
        .fade(duration: const Duration(milliseconds: 300))
        .scale(delay: Duration(milliseconds: index * 50));
  }
}
