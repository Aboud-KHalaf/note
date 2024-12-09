import 'dart:io';
import 'package:flutter/material.dart';
import 'package:note/core/helpers/functions/ui_functions.dart';
import 'package:note/core/helpers/styles/spacing_h.dart';
import 'package:note/features/notes/domain/entities/note_entity.dart';
import 'package:note/features/notes/presentation/widgets/image_display.dart';
import 'package:note/features/notes/presentation/widgets/notes_folder_list_view.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.cardColor,
    required this.note,
    required this.isSelected,
  });

  final Color cardColor;
  final bool isSelected;
  final NoteEntity note;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color:
            isSelected ? theme.primaryColor.withOpacity(0.5) : theme.cardColor,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: isSelected ? Colors.white : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 5.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch, // This makes children take full width
        mainAxisSize: MainAxisSize.min,
        children: [
          if (note.imageUrl != '' && note.imageUrl != null)
            ImageDisplay(
              image: File(note.imageUrl!),
              onLongPress: () {},
            ),
          SpacingHelper.h2,
          Flexible(
            child: SizedBox(
              width: double.infinity, // Forces full width
              child: Text(
                note.title,
                textDirection: isArbic(note.title[0])
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Flexible(
            child: SizedBox(
              width: double.infinity,
              child: Text(
                note.content,
                textDirection:
                    isArbic(note.content.isNotEmpty ? note.content[0] : 'a')
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                style: const TextStyle(fontSize: 14.0),
                maxLines: 8,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(height: 5),
          NotesFolderListView(
            folders: note.folders,
            colorIdx: note.color,
          )
        ],
      ),
    );
  }
}
