import 'package:dartz/dartz.dart';
import 'package:note/core/error/failures.dart';
import 'package:note/core/use_cases/use_case.dart';
import 'package:note/features/notes/domain/entities/note_entity.dart';
import 'package:note/features/notes/domain/repository/note_repository.dart';

class FetchNotesByFolderUsecase extends UseCase<List<NoteEntity>, String> {
  final NoteRepository noteRepository;

  FetchNotesByFolderUsecase({required this.noteRepository});
  @override
  Future<Either<Failure, List<NoteEntity>>> call([String? parm]) async {
    return await noteRepository.fetchNotesByFolder(folderName: parm!);
  }
}
