import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/features/notes/domain/entities/note_entity.dart';
import 'package:note/features/notes/presentation/manager/fetch_all_notes_cubit/fetch_all_notes_cubit.dart';
import 'package:note/features/notes/presentation/widgets/empty_notes.dart';
import 'package:note/features/notes/presentation/widgets/note_staggered_grid_view.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
                )
                  .animate()
                  .fade(duration: const Duration(milliseconds: 300))
                  .scale(delay: const Duration(milliseconds: 100));
        } else if (state is FetchAllNotesFaiure) {
          return Center(
            child: Text(
              state.errMessage,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          )
              .animate()
              .fade(duration: const Duration(milliseconds: 300))
              .shake(delay: const Duration(milliseconds: 100));
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          )
              .animate()
              .fade(duration: const Duration(milliseconds: 300))
              .scale(delay: const Duration(milliseconds: 100));
        }
      },
    );
  }
}
