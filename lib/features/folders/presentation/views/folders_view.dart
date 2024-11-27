import 'package:flutter/material.dart';
import 'package:note/core/helpers/colors/app_colors.dart';
import 'package:note/core/helpers/functions/ui_functions.dart';

import '../widgets/folder_view_body.dart';

class FoldersView extends StatelessWidget {
  const FoldersView({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      body: const FoldersViewBody(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.primaryColor,
        onPressed: () async {
          showAddFolderDialog(context: context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
