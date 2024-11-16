import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:note/features/notes/domain/entities/note_entity.dart';
import 'package:note/features/notes/presentation/manager/fetch_all_notes_cubit/fetch_all_notes_cubit.dart';
import 'package:note/features/notes/presentation/widgets/empty_notes.dart';
import 'package:note/features/notes/presentation/widgets/note_staggered_grid_view.dart';

class AllNotesViewBody extends StatelessWidget {
  final bool isSelectionMode;
  final List<NoteEntity> selectedNotes;
  final void Function(NoteEntity) onNoteTap;

  const AllNotesViewBody({
    super.key,
    required this.isSelectionMode,
    required this.selectedNotes,
    required this.onNoteTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchAllNotesCubit, FetchAllNotesState>(
      builder: (context, state) {
        if (state is FetchAllNotesSuccess) {
          return (state.notes.isEmpty)
              ? const EmptyNotes()
              : NotesStaggeredGridView(
                  selectedNotes: selectedNotes,
                  isSelectionMode: isSelectionMode,
                  onNoteTap: onNoteTap,
                  notes: state.notes,
                );
        } else if (state is FetchAllNotesFaiure) {
          return Center(child: Text(state.errMessage));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
