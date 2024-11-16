import 'package:dartz/dartz.dart';
import 'package:note/core/error/failures.dart';
import 'package:note/features/folders/domain/entities/folder_entity.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;

abstract interface class FolderRepository {
  ResultFuture<Unit> createFolder({required FolderEntity folder});
  ResultFuture<Unit> editFolder({required FolderEntity folder});
  ResultFuture<Unit> deleteFolder({required FolderEntity folder});
  ResultFuture<List<FolderEntity>> fetchAllFolders();
  ResultFuture<Unit> synceNotes();
}
