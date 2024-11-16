import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/features/notes/domain/entities/note_entity.dart';
import 'package:note/features/notes/presentation/manager/fetch_notes_by_folder_cubit.dart/fetch_notes_by_folder_cubit.dart';

import '../../../notes/presentation/widgets/note_staggered_grid_view.dart';

class FolderNotesViewBody extends StatelessWidget {
  final bool isSelectionMode;
  final List<NoteEntity> selectedNotes;
  final void Function(NoteEntity) onNoteTap;
  final String? folder;

  const FolderNotesViewBody({
    super.key,
    required this.isSelectionMode,
    required this.selectedNotes,
    required this.onNoteTap,
    this.folder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchNotesByFolderCubit, FetchNotesByFolderState>(
      builder: (context, state) {
        if (state is FetchNotesByFolderSuccess) {
          return NotesStaggeredGridView(
            folder: folder,
            selectedNotes: selectedNotes,
            isSelectionMode: isSelectionMode,
            onNoteTap: onNoteTap,
            notes: state.notes,
          );
        } else if (state is FetchNotesByFolderFailure) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
