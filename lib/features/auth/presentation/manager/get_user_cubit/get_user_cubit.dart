import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/features/auth/domain/usecases/get_user_data_usecase.dart';

import '../../../../../core/entites/user_entity.dart';

part 'get_user_state.dart';

class GetUserCubit extends Cubit<GetUserState> {
  GetUserCubit(this.getUserDataUsecase) : super(GetUserInitial());

  final GetUserDataUsecase getUserDataUsecase;

  Future<void> getUserData() async {
    emit(GetUserLoading());

    final res = await getUserDataUsecase.call();

    res.fold((failure) {
      emit(GetUserFailuer(errMessage: failure.message));
    }, (user) {
      emit(GetUserSuccess(user: user));
    });
  }
}
