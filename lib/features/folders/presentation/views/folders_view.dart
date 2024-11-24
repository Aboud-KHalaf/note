import 'package:flutter/material.dart';
import 'package:note/core/helpers/colors/app_colors.dart';
import 'package:note/core/helpers/functions/ui_functions.dart';

import '../widgets/folder_view_body.dart';

class FoldersView extends StatelessWidget {
  const FoldersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const FoldersViewBody(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () async {
          showAddFolderDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
