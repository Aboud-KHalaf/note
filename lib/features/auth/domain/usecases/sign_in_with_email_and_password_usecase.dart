import 'package:dartz/dartz.dart';
import 'package:note/core/error/failures.dart';
import 'package:note/core/entites/user_entity.dart';
import 'package:note/features/auth/domain/repositories/auth_repository.dart';

class SignInWithEmailAndPasswordUsecase {
  final AuthRepository authRepository;

  SignInWithEmailAndPasswordUsecase({required this.authRepository});

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  }) async {
    return await authRepository.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
