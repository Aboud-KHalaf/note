import 'package:dartz/dartz.dart';
import 'package:note/core/error/failures.dart';
import 'package:note/core/entites/user_entity.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;

abstract interface class AuthRepository {
  ResultFuture<UserEntity> signUpWithEmailAndPassword(
      {required String name, required String email, required String password});
  ResultFuture<UserEntity> signInWithEmailAndPassword(
      {required String email, required String password});
  // ResultFuture<Unit> logOut();
  ResultFuture<Unit> googleSignIn();

  Future<Either<Failure, UserEntity>> getUserData();
  Future<bool> isUserLoggedIn();
  // Future<void> signOut();
}
