import 'package:dartz/dartz.dart';
import 'package:note/core/error/failures.dart';
import 'package:note/features/notes/domain/entities/note_entity.dart';
import 'package:note/features/notes/domain/repository/note_repository.dart';

class FetchAllNotesUsecase {
  final NoteRepository noteRepository;

  FetchAllNotesUsecase({required this.noteRepository});

  Future<Either<Failure, List<NoteEntity>>> call() async {
    return await noteRepository.fetchAllLocalNotes();
  }
}
