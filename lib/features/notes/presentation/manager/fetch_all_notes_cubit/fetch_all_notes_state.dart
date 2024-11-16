part of 'fetch_all_notes_cubit.dart';

@immutable
sealed class FetchAllNotesState {}

final class FetchAllNotesInitial extends FetchAllNotesState {}

final class FetchAllNotesLoading extends FetchAllNotesState {}

final class FetchAllNotesFaiure extends FetchAllNotesState {
  final String errMessage;

  FetchAllNotesFaiure({required this.errMessage});
}

final class FetchAllNotesSuccess extends FetchAllNotesState {
  final List<NoteEntity> notes;

  FetchAllNotesSuccess({required this.notes});
}

final class FetchAllRemoteNotesSuccess extends FetchAllNotesState {}
