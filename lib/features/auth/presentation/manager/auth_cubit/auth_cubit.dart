import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/core/entites/user_entity.dart';
import 'package:note/features/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:note/features/auth/domain/usecases/is_user_logged_in_usecase.dart';
import 'package:note/features/auth/domain/usecases/sign_in_with_email_and_password_usecase.dart';
import 'package:note/features/auth/domain/usecases/sign_up_with_email_and_password_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
    this.signUpWithEmailAndPasswordUsecase,
    this.signInWithEmailAndPasswordUsecase,
    this.isUserLoggedInUseCase,
    this.googleSignInUsecase,
  ) : super(AuthInitial());

  final SignUpWithEmailAndPasswordUsecase signUpWithEmailAndPasswordUsecase;
  final SignInWithEmailAndPasswordUsecase signInWithEmailAndPasswordUsecase;
  final GoogleSignInUsecase googleSignInUsecase;
  final IsUserLoggedInUseCase isUserLoggedInUseCase;

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    //
    emit(AuthLoading());
    //
    final res = await signUpWithEmailAndPasswordUsecase(
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
    final res = await signInWithEmailAndPasswordUsecase(
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
    final bool res = await isUserLoggedInUseCase.call();
    if (res) {
      emit(UserLoggedIn());
    }
  }

  //

  Future<void> googleSignIn() async {
    emit(AuthLoading());
    var res = await googleSignInUsecase.call();
    res.fold((failure) {
      emit(AuthFailure(errMessage: failure.message));
    }, (unit) {
      emit(AuthSuccess(
          user: UserEntity(id: 'id', name: 'name', email: 'email')));
    });
  }
}
