import 'package:flutter/material.dart';
import 'package:note/core/helpers/functions/ui_functions.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../widgets/folder_view_body.dart';

class FoldersView extends StatelessWidget {
  const FoldersView({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: const FoldersViewBody()
          .animate()
          .fade(duration: const Duration(milliseconds: 300))
          .slideY(begin: 0.1, end: 0),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.primaryColor,
        onPressed: () async {
          showAddFolderDialog(context: context);
        },
        child: const Icon(Icons.add),
      )
          .animate()
          .scale(duration: const Duration(milliseconds: 300))
          .fade(duration: const Duration(milliseconds: 300)),
    );
  }
}
