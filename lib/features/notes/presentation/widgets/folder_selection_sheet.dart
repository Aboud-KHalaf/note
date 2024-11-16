import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/core/helpers/colors/app_colors.dart';
import 'package:note/features/folders/domain/entities/folder_entity.dart';
import 'package:note/features/folders/presentation/manager/cubit/folder_actions_cubit.dart';

class FolderSelectionSheet extends StatelessWidget {
  final List<String> currentNoteFolders;
  final Function(String, bool) onFolderToggled;

  const FolderSelectionSheet({
    super.key,
    required this.currentNoteFolders,
    required this.onFolderToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<FolderActionsCubit, FolderActionsState>(
        builder: (context, state) {
          if (state is FetchFoldersNameSuccess) {
            List<FolderEntity> folders = state.folders;

            return ListView.builder(
              itemCount: folders.length,
              itemBuilder: (context, index) {
                return StatefulBuilder(
                  builder: (context, setState) => CheckboxListTile(
                    title: Text(folders[index].name),
                    secondary: Icon(
                      Icons.folder,
                      color: AppColors.cardColors[folders[index].color],
                    ),
                    value: (currentNoteFolders.contains(folders[index].name)),
                    onChanged: (bool? value) {
                      setState(() {
                        onFolderToggled(folders[index].name, value ?? false);
                      });
                    },
                  ),
                );
              },
            );
          }
          return const SizedBox(
            width: double.infinity,
          );
        },
      ),
    );
  }
}
