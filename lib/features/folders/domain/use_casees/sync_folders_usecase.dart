import 'package:dartz/dartz.dart';
import 'package:note/core/error/failures.dart';
import 'package:note/core/use_cases/use_case.dart';
import 'package:note/features/folders/domain/repositories/folder_repo.dart';

class SyncFoldersUsecase extends UseCase<Unit, NoParameter> {
  final FolderRepository folderRepository;

  SyncFoldersUsecase({required this.folderRepository});
  @override
  Future<Either<Failure, Unit>> call([NoParameter? parm]) {
    return folderRepository.synceFolders();
  }
}
