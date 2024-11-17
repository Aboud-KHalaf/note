part of 'sync_folders_cubit.dart';

@immutable
sealed class SyncFoldersState {}

final class SuncFoldersInitial extends SyncFoldersState {}

final class SuncFoldersLoading extends SyncFoldersState {}

final class SuncFoldersSuccess extends SyncFoldersState {}

final class SuncFoldersFailure extends SyncFoldersState {}
