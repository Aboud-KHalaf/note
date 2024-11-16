import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/features/folders/presentation/manager/cubit/folder_actions_cubit.dart';
import 'package:note/features/folders/presentation/widgets/empty_folders.dart';
import 'package:note/features/folders/presentation/widgets/folders_grid_view.dart';

class FoldersViewBody extends StatelessWidget {
  const FoldersViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FolderActionsCubit, FolderActionsState>(
      builder: (context, state) {
        if (state is FetchFoldersNameSuccess) {
          return (state.folders.isEmpty)
              ? const EmptyFolders()
              : FoldersGridView(
                  folders: state.folders,
                );
        } else if (state is FolderActionsFailure) {
          return Text(state.errMessage);
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
