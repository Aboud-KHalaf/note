import 'package:dartz/dartz.dart';
import 'package:note/core/error/failures.dart';
import 'package:note/core/use_cases/use_case.dart';
import 'package:note/features/auth/domain/repositories/auth_repository.dart';

class SignOutUsecase extends UseCase<Unit, NoParameter> {
  final AuthRepository authRepository;

  SignOutUsecase({required this.authRepository});
  @override
  Future<Either<Failure, Unit>> call([NoParameter? parm]) async {
    return await authRepository.signOut();
  }
}
