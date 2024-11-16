import 'package:dartz/dartz.dart';
import 'package:note/core/error/failures.dart';
import 'package:note/core/use_cases/use_case.dart';
import 'package:note/features/notes/domain/entities/required_data_entity.dart';
import 'package:note/features/notes/domain/repository/note_repository.dart';

class UpdateNoteUsecase extends UseCase<Unit, RequiredDataEntity> {
  final NoteRepository noteRepository;

  UpdateNoteUsecase({required this.noteRepository});

  @override
  Future<Either<Failure, Unit>> call([RequiredDataEntity? parm]) async {
    return await noteRepository.updateNote(data: parm!);
  }
}
