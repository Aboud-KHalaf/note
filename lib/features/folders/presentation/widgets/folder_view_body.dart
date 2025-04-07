import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/features/folders/presentation/manager/folder_actions_cubit/folder_actions_cubit.dart';
import 'package:note/features/folders/presentation/widgets/empty_folders.dart';
import 'package:note/features/folders/presentation/widgets/folders_grid_view.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
                )
                  .animate()
                  .fade(duration: const Duration(milliseconds: 300))
                  .scale(delay: const Duration(milliseconds: 100));
        } else if (state is FolderActionsFailure) {
          return Center(
            child: Text(
              state.errMessage,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          )
              .animate()
              .fade(duration: const Duration(milliseconds: 300))
              .shake(delay: const Duration(milliseconds: 100));
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          )
              .animate()
              .fade(duration: const Duration(milliseconds: 300))
              .scale(delay: const Duration(milliseconds: 100));
        }
      },
    );
  }
}
