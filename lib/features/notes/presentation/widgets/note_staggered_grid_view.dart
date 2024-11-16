import 'package:flutter/material.dart';
import 'package:note/features/notes/presentation/widgets/note_card.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../../../../core/helpers/colors/app_colors.dart';
import '../../domain/entities/note_entity.dart';
import '../views/note_detail_view.dart';

class NotesStaggeredGridView extends StatelessWidget {
  const NotesStaggeredGridView({
    super.key,
    required this.selectedNotes,
    required this.isSelectionMode,
    required this.onNoteTap,
    required this.notes,
    this.folder,
  });

  final List<NoteEntity> selectedNotes;
  final List<NoteEntity> notes;
  final bool isSelectionMode;
  final Function(NoteEntity p1) onNoteTap;
  final String? folder;

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final isSelected = selectedNotes.contains(notes[index]);
        return GestureDetector(
          onTap: () {
            if (isSelectionMode) {
              onNoteTap(notes[index]);
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NoteDetailScreen(
                    folder: folder,
                    note: notes[index],
                  ),
                ),
              );
            }
          },
          onLongPress: () => onNoteTap(notes[index]), // Start selection mode
          child: NoteCard(
            note: notes[index],
            cardColor: AppColors.cardColors[notes[index].color],
            isSelected: isSelected,
          ),
        );
      },
      staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
      mainAxisSpacing: 10.0,
      crossAxisSpacing: 10.0,
    );
  }
}
