import 'package:dartz/dartz.dart';
import 'package:note/core/error/failures.dart';
import 'package:note/core/use_cases/use_case.dart';
import 'package:note/features/notes/domain/entities/note_entity.dart';
import 'package:note/features/search/domain/repositories/search_repository.dart';

class SearchUseCase extends UseCase<List<NoteEntity>, String> {
  final SearchRepository searchRepository;
  SearchUseCase({required this.searchRepository});
  @override
  Future<Either<Failure, List<NoteEntity>>> call([String? parm]) {
    return searchRepository.serach(text: parm!);
  }
}
