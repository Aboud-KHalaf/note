import 'package:dartz/dartz.dart';
import 'package:note/core/error/failures.dart';
import 'package:note/core/use_cases/use_case.dart';
import 'package:note/features/notes/domain/repository/note_repository.dart';

class SynceNotesUsecase extends UseCase<Unit, NoParameter> {
  final NoteRepository noteRepository;

  SynceNotesUsecase({required this.noteRepository});
  @override
  Future<Either<Failure, Unit>> call([NoParameter? parm]) {
    return noteRepository.synceNotes();
  }
}
