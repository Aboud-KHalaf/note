import 'package:flutter/material.dart';
import 'package:note/features/notes/presentation/widgets/notes_folder_item.dart';

class NotesFolderListView extends StatelessWidget {
  const NotesFolderListView({
    required this.folders,
    super.key,
  });

  final List<String> folders;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: folders.length,
        itemBuilder: (context, index) {
          return (folders[index] != "")
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: NotesFolderItem(
                    folder: folders[index],
                  ),
                )
              : const SizedBox();
        },
      ),
    );
  }
}
