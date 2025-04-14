import 'package:dartz/dartz.dart';
import 'package:note/core/error/failures.dart';
import 'package:note/features/auth/data/data_soureces/auth_local_data_source.dart';
import 'package:note/features/auth/data/data_soureces/auth_remote_data_source.dart';
import 'package:note/features/auth/data/models/user_model.dart';
import 'package:note/features/auth/domain/repositories/auth_repository.dart';

import '../../../../core/error/exceptions.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  AuthRepositoryImpl(
      {required this.authLocalDataSource, required this.authRemoteDataSource});

  @override
  Future<Either<Failure, UserModel>> getUserData() async {
    try {
      final userData = await authLocalDataSource.fetchLocalUserData();

      return right(userData);
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    }
  }

  ///

  @override
  Future<Either<Failure, UserModel>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _handleAuth(
      authAction: () => authRemoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
  }

  ///

  @override
  Future<Either<Failure, UserModel>> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _handleAuth(
      authAction: () => authRemoteDataSource.signUpWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  ///

  Future<Either<Failure, UserModel>> _handleAuth({
    required Future<UserModel> Function() authAction,
  }) async {
    try {
      final userModel = await authAction();
      await authLocalDataSource.insertUserDataLocaly(userModel: userModel);
      return right(userModel);
    } on ServerException catch (e) {
      return left(ServerFailure(e.toString()));
    } catch (e) {
      return left(const UnknownFailure());
    }
  }

  ///

  @override
  Future<bool> isUserLoggedIn() {
    return authRemoteDataSource.isUserLoggedIn;
  }

  @override
  ResultFuture<Unit> googleSignIn() async {
    try {
      await authRemoteDataSource.googleSignIn();
      return right(unit);
    } on ServerException catch (e) {
      return left(ServerFailure(e.toString()));
    } catch (e) {
      return left(const UnknownFailure());
    }
  }

  @override
  ResultFuture<Unit> signOut() async {
    try {
      await authRemoteDataSource.signOut();
      return right(unit);
    } on ServerException catch (e) {
      return left(ServerFailure(e.toString()));
    } catch (e) {
      return left(const UnknownFailure());
    }
  }
}