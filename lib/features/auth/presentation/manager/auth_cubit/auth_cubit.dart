import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/core/entites/user_entity.dart';
import 'package:note/features/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:note/features/auth/domain/usecases/is_user_logged_in_usecase.dart';
import 'package:note/features/auth/domain/usecases/sign_in_with_email_and_password_usecase.dart';
import 'package:note/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:note/features/auth/domain/usecases/sign_up_with_email_and_password_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
    this._signUpWithEmailAndPasswordUsecase,
    this._signInWithEmailAndPasswordUsecase,
    this._isUserLoggedInUseCase,
    this._googleSignInUsecase,
    this._signOutUsecase,
  ) : super(AuthInitial());

  final SignUpWithEmailAndPasswordUsecase _signUpWithEmailAndPasswordUsecase;
  final SignInWithEmailAndPasswordUsecase _signInWithEmailAndPasswordUsecase;
  final GoogleSignInUsecase _googleSignInUsecase;
  final IsUserLoggedInUseCase _isUserLoggedInUseCase;
  final SignOutUsecase _signOutUsecase;

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    //
    emit(AuthLoading());
    //
    final res = await _signUpWithEmailAndPasswordUsecase(
      name: name,
      email: email,
      password: password,
    );
    //
    res.fold(
      (failure) {
        emit(AuthFailure(errMessage: failure.message));
      },
      (user) {
        emit(AuthSuccess(user: user));
      },
    );
    //
  }

  ////

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    //
    emit(AuthLoading());
    //
    final res = await _signInWithEmailAndPasswordUsecase(
      email: email,
      password: password,
    );
    //
    res.fold(
      (failure) {
        emit(AuthFailure(errMessage: failure.message));
      },
      (user) {
        emit(AuthSuccess(user: user));
      },
    );
  }

  ///

  ///

  Future<void> isUserLoggedIn() async {
    final bool res = await _isUserLoggedInUseCase.call();
    if (res) {
      emit(UserLoggedIn());
    }
  }

  //

  Future<void> googleSignIn() async {
    emit(AuthLoading());
    var res = await _googleSignInUsecase.call();
    res.fold((failure) {
      emit(AuthFailure(errMessage: failure.message));
    }, (unit) {
      emit(AuthSuccess(
          user: UserEntity(id: 'id', name: 'name', email: 'email')));
    });
  }

  Future<void> signOut() async {
    emit(AuthLoading());
    var res = await _signOutUsecase.call();
    res.fold((failure) {
      emit(AuthFailure(errMessage: failure.message));
    }, (unit) {
      emit(AuthLogOutSuccess());
    });
  }
}
