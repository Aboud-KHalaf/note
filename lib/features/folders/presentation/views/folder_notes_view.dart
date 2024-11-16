import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:note/core/helpers/colors/app_colors.dart';
import 'package:note/core/helpers/localization/app_localization.dart';
import 'package:note/features/folders/presentation/widgets/folder_notes_view_body.dart';
import 'package:note/features/folders/presentation/widgets/options_menu_button.dart';
import 'package:note/features/notes/domain/entities/note_entity.dart';
import 'package:note/features/notes/presentation/manager/delete_note_cubit/delete_note_cubit.dart';
import 'package:note/features/notes/presentation/manager/fetch_notes_by_folder_cubit.dart/fetch_notes_by_folder_cubit.dart';

class FolderNotesView extends StatefulWidget {
  const FolderNotesView({
    super.key,
    required this.folderName,
  });
  final String folderName;

  @override
  State<FolderNotesView> createState() => _FolderNotesViewState();
}

class _FolderNotesViewState extends State<FolderNotesView> {
  bool isSelectionMode = false; // Flag to check if selection mode is active
  List<NoteEntity> selectedNotes = []; // List to track selected notes' indices

  @override
  void initState() {
    context
        .read<FetchNotesByFolderCubit>()
        .fetchNotesByFolder(folderName: widget.folderName);
    super.initState();
  }

  void toggleSelectionMode(NoteEntity note) {
    setState(() {
      if (isSelectionMode) {
        // Add or remove note index from selected list
        if (selectedNotes.contains(note)) {
          selectedNotes.remove(note);
          if (selectedNotes.isEmpty) {
            isSelectionMode = false; // Exit selection mode if none selected
          }
        } else {
          selectedNotes.add(note);
        }
      } else {
        // Start selection mode
        isSelectionMode = true;
        selectedNotes.add(note);
      }
    });
  }

  void clearSelection() {
    setState(() {
      isSelectionMode = false;
      selectedNotes.clear();
    });
  }

  void deleteSelection() {
    for (var note in selectedNotes) {
      BlocProvider.of<DeleteNoteCubit>(context).deleteNote(note: note);
    }
    context
        .read<FetchNotesByFolderCubit>()
        .fetchNotesByFolder(folderName: widget.folderName);
    setState(() {
      isSelectionMode = false;
      selectedNotes.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isSelectionMode ? _buildSelcetionModeAppBar() : _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FolderNotesViewBody(
          folder: widget.folderName,
          isSelectionMode: isSelectionMode,
          selectedNotes: selectedNotes,
          onNoteTap: toggleSelectionMode,
        ),
      ),
    );
  }

  AppBar _buildSelcetionModeAppBar() {
    return AppBar(
      title: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '${selectedNotes.length} ',
              style: const TextStyle(color: AppColors.primary),
            ),
            TextSpan(
              text: 'selected'.tr(context),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
          onPressed: deleteSelection, // Exit selection mode
        ),
      ],
      leading: IconButton(
        icon: const Icon(
          Icons.clear,
          color: Colors.green,
        ),
        onPressed: clearSelection, // Exit selection mode
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '${widget.folderName} ',
              style: const TextStyle(color: AppColors.primary),
            ),
            TextSpan(
              text: 'folder'.tr(context),
            ),
          ],
        ),
      ),
      actions: const [OptionsMenuButton()],
      centerTitle: true,
    );
  }
}
