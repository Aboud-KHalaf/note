import 'package:dartz/dartz.dart';
import 'package:note/core/error/failures.dart';
import 'package:note/core/use_cases/use_case.dart';
import 'package:note/features/notes/domain/entities/note_entity.dart';
import 'package:note/features/notes/domain/entities/required_data_entity.dart';
import 'package:note/features/notes/domain/repository/note_repository.dart';

class InsertNoteUsecase extends UseCase<NoteEntity, RequiredDataEntity> {
  final NoteRepository noteRepository;

  InsertNoteUsecase({required this.noteRepository});

  @override
  Future<Either<Failure, NoteEntity>> call([RequiredDataEntity? parm]) async {
    return await noteRepository.insertNote(
      data: parm!,
    );
  }
}
