import 'package:dartz/dartz.dart';
import 'package:note/core/error/failures.dart';
import 'package:note/features/notes/data/models/note_model.dart';
import 'package:note/features/notes/domain/repository/note_repository.dart';

class DeleteNoteUsecase {
  final NoteRepository noteRepository;

  DeleteNoteUsecase({required this.noteRepository});

  Future<Either<Failure, Unit>> call({required NoteModel note}) async {
    return await noteRepository.deleteNote(note: note);
  }
}
