import 'package:note/features/auth/domain/repositories/auth_repository.dart';

class IsUserLoggedInUseCase {
  final AuthRepository authRepository;

  IsUserLoggedInUseCase({required this.authRepository});

  Future<bool> call() {
    return authRepository.isUserLoggedIn();
  }
}
