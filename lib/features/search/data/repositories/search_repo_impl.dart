import 'package:dartz/dartz.dart';
import 'package:note/core/error/failures.dart';
import 'package:note/features/notes/data/models/note_model.dart';
import 'package:note/features/notes/domain/entities/note_entity.dart';
import 'package:note/features/search/data/data_sources/search_local_data_source.dart';
import 'package:note/features/search/domain/repositories/search_repository.dart';

class SearchRepoImpl implements SearchRepository {
  final SearchLocalDataSourceImpl searchLocalDataSourceImpl;

  SearchRepoImpl({required this.searchLocalDataSourceImpl});
  @override
  Future<Either<Failure, List<NoteEntity>>> serach(
      {required String text}) async {
    try {
      List<NoteModel> notes =
          await searchLocalDataSourceImpl.searchNotes(query: text);

      return right(notes);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
