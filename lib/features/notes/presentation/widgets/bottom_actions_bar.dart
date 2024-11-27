import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/core/helpers/styles/spacing_h.dart';

import '../../domain/entities/note_entity.dart';
import '../manager/delete_note_cubit/delete_note_cubit.dart';

class BottomActionBar extends StatelessWidget {
  final NoteEntity? note;
  final VoidCallback onColorPressed;
  final VoidCallback onImagePressed;
  final VoidCallback onFolderPressed;

  const BottomActionBar({
    super.key,
    required this.note,
    required this.onColorPressed,
    required this.onImagePressed,
    required this.onFolderPressed,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      color: theme.scaffoldBackgroundColor,
      height: 60,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (note != null)
              ElevatedButton(
                onPressed: () {
                  context.read<DeleteNoteCubit>().deleteNote(note: note!);
                },
                child: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            SpacingHelper.w2,
            ElevatedButton(
              onPressed: onColorPressed,
              child: Icon(
                Icons.color_lens,
                color: theme.primaryColor,
              ),
            ),
            SpacingHelper.w2,
            ElevatedButton(
              onPressed: onImagePressed,
              child: const Icon(Icons.add_photo_alternate),
            ),
            SpacingHelper.w2,
            ElevatedButton(
              onPressed: onFolderPressed,
              child: const Icon(Icons.folder),
            ),
          ],
        ),
      ),
    );
  }
}
