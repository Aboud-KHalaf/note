import 'package:dartz/dartz.dart';
import 'package:note/core/error/failures.dart';
import 'package:note/features/notes/domain/entities/note_entity.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<NoteEntity>>> serach({required String text});
}
