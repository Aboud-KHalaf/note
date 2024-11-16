import 'package:dartz/dartz.dart';
import 'package:note/core/error/failures.dart';
import 'package:note/features/auth/domain/repositories/auth_repository.dart';

import '../../../../core/entites/user_entity.dart';

class GetUserDataUsecase {
  final AuthRepository authRepository;

  GetUserDataUsecase({required this.authRepository});

  Future<Either<Failure, UserEntity>> call() async {
    return authRepository.getUserData();
  }
}
