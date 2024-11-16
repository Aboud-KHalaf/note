import 'package:flutter/material.dart';
import 'package:note/features/folders/presentation/views/folders_view.dart';
import 'package:note/features/notes/presentation/views/all_notes_view.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: TabBarView(
        children: [
          AllNotesView(),
          FoldersView(),
        ],
      ),
    );
  }
}
