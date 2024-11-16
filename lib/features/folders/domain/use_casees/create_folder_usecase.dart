import 'package:dartz/dartz.dart';
import 'package:note/core/error/failures.dart';
import 'package:note/core/use_cases/use_case.dart';
import 'package:note/features/folders/domain/entities/folder_entity.dart';
import 'package:note/features/folders/domain/repositories/folder_repo.dart';

class CreateFolderUsecase extends UseCase<Unit, FolderEntity> {
  final FolderRepository folderRepository;

  CreateFolderUsecase({required this.folderRepository});
  @override
  Future<Either<Failure, Unit>> call([FolderEntity? parm]) async {
    return folderRepository.createFolder(folder: parm!);
  }
}
