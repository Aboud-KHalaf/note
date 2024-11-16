import 'package:dartz/dartz.dart';
import 'package:note/core/error/failures.dart';
import 'package:note/features/notes/data/models/note_model.dart';
import 'package:note/features/notes/domain/entities/note_entity.dart';
import 'package:note/features/notes/domain/entities/required_data_entity.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;

abstract interface class NoteRepository {
  insertNote({required RequiredDataEntity data});

  ResultFuture<List<NoteEntity>> fetchAllLocalNotes();

  ResultFuture<Unit> deleteNote({required NoteModel note});
  ResultFuture<Unit> updateNote({required RequiredDataEntity data});
  ResultFuture<List<NoteEntity>> fetchNotesByFolder(
      {required String folderName});

  ResultFuture<Unit> fetchAllRemoteNotes();

  ResultFuture<Unit> synceNotes();
}
