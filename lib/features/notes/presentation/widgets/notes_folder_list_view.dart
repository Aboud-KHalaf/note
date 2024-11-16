import 'package:flutter/material.dart';
import 'package:note/features/notes/presentation/widgets/notes_folder_item.dart';

class NotesFolderListView extends StatelessWidget {
  const NotesFolderListView({
    required this.folders,
    super.key,
    required this.colorIdx,
  });

  final List<String> folders;
  final int colorIdx;

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
                    colorIdx: colorIdx,
                    folder: folders[index],
                  ),
                )
              : const SizedBox();
        },
      ),
    );
  }
}
