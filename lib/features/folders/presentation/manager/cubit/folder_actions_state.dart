part of 'folder_actions_cubit.dart';

@immutable
abstract class FolderActionsState {}

class FolderActionsInitial extends FolderActionsState {}

class FolderActionsLoading extends FolderActionsState {}

class FolderActionsSuccess extends FolderActionsState {}

class FetchFoldersNameSuccess extends FolderActionsState {
  final List<FolderEntity> folders;

  FetchFoldersNameSuccess({required this.folders});
}

class FolderActionsFailure extends FolderActionsState {
  final String errMessage;

  FolderActionsFailure({required this.errMessage});
}
