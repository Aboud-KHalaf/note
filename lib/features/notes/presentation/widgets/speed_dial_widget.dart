import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:note/core/helpers/localization/app_localization.dart';

import '../../domain/entities/note_entity.dart';
import '../manager/delete_note_cubit/delete_note_cubit.dart';

class SpeedDialWidget extends StatelessWidget {
  const SpeedDialWidget({
    super.key,
    required this.note,
    required this.onColorPressed,
    required this.onImagePressed,
    required this.onFolderPressed,
  });

  final NoteEntity? note;
  final VoidCallback onColorPressed;
  final VoidCallback onImagePressed;
  final VoidCallback onFolderPressed;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SpeedDial(
      backgroundColor: theme.scaffoldBackgroundColor,
      children: [
        SpeedDialChild(
          child: Icon(
            Icons.color_lens,
            color: theme.primaryColor,
          ),
          label: "color".tr(context),
          onTap: onColorPressed,
        ),
        SpeedDialChild(
          child: const Icon(Icons.add_photo_alternate),
          label: "add_photo".tr(context),
          onTap: onImagePressed,
        ),
        if (note != null)
          SpeedDialChild(
            child: const Icon(Icons.delete, color: Colors.red),
            label: "delete".tr(context),
            onTap: () {
              context.read<DeleteNoteCubit>().deleteNote(note: note!);
            },
          ),
        SpeedDialChild(
          child: const Icon(Icons.folder),
          label: "add_folder".tr(context),
          onTap: onFolderPressed,
        ),
      ],
      child: const Icon(Icons.add),
    );
  }
}
