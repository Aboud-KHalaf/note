import 'package:flutter/material.dart';
import 'package:note/features/folders/domain/entities/folder_entity.dart';
import 'package:note/features/folders/presentation/views/folder_notes_view.dart';

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
      itemCount: folders.length, // Number of items
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns in the grid
        crossAxisSpacing: 10.0, // Space between columns
        mainAxisSpacing: 10.0, // Space between rows
        childAspectRatio: 1.0, // Aspect ratio of the items
      ),
      padding:
          const EdgeInsets.only(top: 36.0, right: 12, left: 12, bottom: 12),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FolderNotesView(
                  folderName: folders[index].name,
                ),
              ),
            );
          },
          child: FolderItem(
            folder: folders[index],
          ),
        );
      },
    );
  }
}
