// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/core/helpers/localization/app_localization.dart';
import 'package:note/core/helpers/styles/fonts_h.dart';
import 'package:note/features/notes/domain/entities/note_entity.dart';
import 'package:note/features/notes/presentation/manager/delete_note_cubit/delete_note_cubit.dart';
import 'package:note/features/notes/presentation/manager/fetch_all_notes_cubit/fetch_all_notes_cubit.dart';
import 'package:note/features/notes/presentation/views/note_detail_view.dart';
import 'package:note/features/notes/presentation/widgets/all_notes_view_body.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/helpers/functions/ui_functions.dart';

class AllNotesView extends StatefulWidget {
  const AllNotesView({
    super.key,
  });

  @override
  State<AllNotesView> createState() => _AllNotesViewState();
}

class _AllNotesViewState extends State<AllNotesView> {
  bool isSelectionMode = false;
  List<NoteEntity> selectedNotes = [];

  void toggleSelectionMode(NoteEntity note) {
    setState(() {
      if (isSelectionMode) {
        if (selectedNotes.contains(note)) {
          selectedNotes.remove(note);
          if (selectedNotes.isEmpty) {
            isSelectionMode = false;
          }
        } else {
          selectedNotes.add(note);
        }
      } else {
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
          BlocProvider.of<FetchAllNotesCubit>(context).fetchAllNotes();

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
      backgroundColor: theme.scaffoldBackgroundColor,
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
      )
          .animate()
          .scale(duration: const Duration(milliseconds: 300))
          .fade(duration: const Duration(milliseconds: 300)),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(
        '${selectedNotes.length} ${"selected".tr(context)}',
        style: FontsStylesHelper.textStyle16.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.delete,
            color: Theme.of(context).colorScheme.error,
          ),
          onPressed: deleteSelection,
        )
            .animate()
            .fade(duration: const Duration(milliseconds: 300))
            .scale(delay: const Duration(milliseconds: 100)),
      ],
      leading: IconButton(
        icon: Icon(
          Icons.clear,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: clearSelection,
      )
          .animate()
          .fade(duration: const Duration(milliseconds: 300))
          .scale(delay: const Duration(milliseconds: 50)),
    );
  }
}
