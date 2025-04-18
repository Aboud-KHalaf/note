import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:note/core/helpers/functions/ui_functions.dart';
import 'package:note/core/helpers/localization/app_localization.dart';
import 'package:note/features/folders/domain/entities/folder_entity.dart';
import 'package:note/features/folders/presentation/manager/folder_actions_cubit/folder_actions_cubit.dart';
import 'package:note/features/folders/presentation/widgets/folder_notes_view_body.dart';
import 'package:note/features/folders/presentation/widgets/options_menu_button.dart';
import 'package:note/features/notes/domain/entities/note_entity.dart';
import 'package:note/features/notes/presentation/manager/delete_note_cubit/delete_note_cubit.dart';
import 'package:note/features/notes/presentation/manager/fetch_all_notes_cubit/fetch_all_notes_cubit.dart';
import 'package:note/features/notes/presentation/manager/fetch_notes_by_folder_cubit.dart/fetch_notes_by_folder_cubit.dart';

class FolderNotesView extends StatefulWidget {
  const FolderNotesView({
    super.key,
    required this.folder,
  });
  final FolderEntity folder;

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
        .fetchNotesByFolder(folderName: widget.folder.name);
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
    showWarning(
        context: context,
        content: 'note_warning_content'.tr(context),
        type: 'delete'.tr(context),
        onDone: () async {
          for (var note in selectedNotes) {
            BlocProvider.of<DeleteNoteCubit>(context).deleteNote(note: note);
          }
          context
              .read<FetchNotesByFolderCubit>()
              .fetchNotesByFolder(folderName: widget.folder.name);
          context.read<FetchAllNotesCubit>().fetchAllNotes();
          setState(() {
            isSelectionMode = false;
            selectedNotes.clear();
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: isSelectionMode
          ? _buildSelcetionModeAppBar(theme.primaryColor)
          : _buildAppBar(theme.primaryColor),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FolderNotesViewBody(
          folder: widget.folder.name,
          isSelectionMode: isSelectionMode,
          selectedNotes: selectedNotes,
          onNoteTap: toggleSelectionMode,
        ),
      ),
    );
  }

  AppBar _buildSelcetionModeAppBar(Color color) {
    return AppBar(
      title: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '${selectedNotes.length} ',
              style: TextStyle(color: color),
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

  AppBar _buildAppBar(Color color) {
    return AppBar(
      title: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '${widget.folder.name} ',
              style: TextStyle(color: color),
            ),
            TextSpan(
              text: 'folder'.tr(context),
            ),
          ],
        ),
      ),
      actions: [
        OptionsMenuButton(
          onEditSelected: _oneditFolder,
          ondeleteSelected: _ondelteFolder,
        )
      ],
      centerTitle: true,
    );
  }

  Future<void> _deleteFolder() async {
    await context.read<FolderActionsCubit>().deleteFolder(
          folder: widget.folder,
        );
    if (mounted) {
      Navigator.of(context).pop();
      await context.read<FolderActionsCubit>().fetchAllFolders();
    }
  }

  Future<void> _ondelteFolder() async {
    showWarning(
      context: context,
      content: "folder_warning_content".tr(context),
      type: "delete".tr(context),
      onDone: _deleteFolder,
    );
  }

  Future<void> _oneditFolder() async {
    await showAddFolderDialog(context: context, folderEntity: widget.folder);
    if (mounted) {
      Navigator.pop(context);
    }
  }
}
