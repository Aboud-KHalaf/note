part of 'search_cubit.dart';

@immutable
sealed class SearchState {}

final class SearchInitial extends SearchState {}

class SearchEmpty extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<NoteEntity> notes;

  SearchSuccess({required this.notes});
}

class SearchFailure extends SearchState {
  final String mesage;

  SearchFailure({required this.mesage});
}
