part of 'upload_note_cubit.dart';

@immutable
sealed class UploadNoteState {}

final class UploadNoteInitial extends UploadNoteState {}

final class UploadNoteLoading extends UploadNoteState {}

final class UploadNoteSuccess extends UploadNoteState {}

final class UploadNoteFailure extends UploadNoteState {
  final String errmessage;

  UploadNoteFailure({required this.errmessage});
}
