part of 'fetch_notes_by_folder_cubit.dart';

@immutable
sealed class FetchNotesByFolderState {}

class FetchNotesByFolderInitial extends FetchNotesByFolderState {}

class FetchNotesByFolderLoading extends FetchNotesByFolderState {}

class FetchNotesByFolderSuccess extends FetchNotesByFolderState {
  final List<NoteEntity> notes;

  FetchNotesByFolderSuccess({required this.notes});
}

class FetchNotesByFolderFailure extends FetchNotesByFolderState {
  final String message;

  FetchNotesByFolderFailure({required this.message});
}
