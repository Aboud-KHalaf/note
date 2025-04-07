import 'package:flutter/material.dart';
import 'package:note/features/folders/domain/entities/folder_entity.dart';
import 'package:note/features/folders/presentation/views/folder_notes_view.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../notes/presentation/widgets/folder_item.dart';

class FoldersGridView extends StatelessWidget {
  const FoldersGridView({
    super.key,
    required this.folders,
  });

  final List<FolderEntity> folders;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: folders.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 1.0,
      ),
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FolderNotesView(
                  folder: folders[index],
                ),
              ),
            );
          },
          child: FolderItem(
            folder: folders[index],
          )
              .animate()
              .fade(duration: const Duration(milliseconds: 300))
              .scale(delay: Duration(milliseconds: index * 50)),
        );
      },
    );
  }
}
