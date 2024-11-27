// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/core/helpers/colors/app_colors.dart';
import 'package:note/core/helpers/localization/app_localization.dart';

import 'package:note/features/notes/domain/entities/note_entity.dart';
import 'package:note/features/notes/presentation/manager/delete_note_cubit/delete_note_cubit.dart';
import 'package:note/features/notes/presentation/manager/fetch_all_notes_cubit/fetch_all_notes_cubit.dart';
import 'package:note/features/notes/presentation/views/note_detail_view.dart';
import 'package:note/features/notes/presentation/widgets/all_notes_view_body.dart';

class AllNotesView extends StatefulWidget {
  const AllNotesView({
    super.key,
  });

  @override
  State<AllNotesView> createState() => _AllNotesViewState();
}

class _AllNotesViewState extends State<AllNotesView> {
  bool isSelectionMode = false; // Flag to check if selection mode is active
  List<NoteEntity> selectedNotes = []; // List to track selected notes' indices

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
    BlocProvider.of<FetchAllNotesCubit>(context).fetchAllNotes();

    setState(() {
      isSelectionMode = false;
      selectedNotes.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: isSelectionMode ? _buildAppBar() : null,
      body: AllNotesViewBody(
        isSelectionMode: isSelectionMode,
        selectedNotes: selectedNotes,
        onNoteTap: toggleSelectionMode,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.primaryColor,
        onPressed: () => Navigator.of(context).pushNamed(NoteDetailScreen.id),
        child: const Icon(Icons.add),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('${selectedNotes.length} ${"selected".tr(context)}'),
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
}
