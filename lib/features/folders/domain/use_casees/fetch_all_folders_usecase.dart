import 'package:dartz/dartz.dart';
import 'package:note/core/error/failures.dart';
import 'package:note/core/use_cases/use_case.dart';
import 'package:note/features/folders/domain/entities/folder_entity.dart';
import 'package:note/features/folders/domain/repositories/folder_repo.dart';

class FetchAllFolderUsecase extends UseCase<List<FolderEntity>, NoParameter> {
  final FolderRepository folderRepository;

  FetchAllFolderUsecase({required this.folderRepository});
  @override
  Future<Either<Failure, List<FolderEntity>>> call([NoParameter? parm]) async {
    return await folderRepository.fetchAllFolders();
  }
}
