part of 'sync_notes_cubit.dart';

@immutable
sealed class SyncNotesState {}

final class SyncNotesInitial extends SyncNotesState {}

final class SyncNotesLoading extends SyncNotesState {}

final class SyncNotesFailure extends SyncNotesState {
  final String errMessage;

  SyncNotesFailure({required this.errMessage});
}

final class SyncNotesSuccess extends SyncNotesState {}
