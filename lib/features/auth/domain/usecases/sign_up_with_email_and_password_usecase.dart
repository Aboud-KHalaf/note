import 'package:dartz/dartz.dart';
import 'package:note/core/error/failures.dart';
import 'package:note/core/entites/user_entity.dart';
import 'package:note/features/auth/domain/repositories/auth_repository.dart';

class SignUpWithEmailAndPasswordUsecase {
  final AuthRepository authRepository;

  SignUpWithEmailAndPasswordUsecase({required this.authRepository});

  Future<Either<Failure, UserEntity>> call({
    required String name,
    required String email,
    required String password,
  }) async {
    return await authRepository.signUpWithEmailAndPassword(
      name: name,
      email: email,
      password: password,
    );
  }
}
