abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class UserNotFoundFailure extends Failure {
  const UserNotFoundFailure() : super('User Not Found');
}

class UnknownFailure extends Failure {
  const UnknownFailure() : super("An unknown error occurred.");
}
