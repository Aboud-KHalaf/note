import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/core/services/shared_preferences_services.dart';
import 'package:note/features/auth/domain/usecases/get_user_data_usecase.dart';

import '../../../../../core/entites/user_entity.dart';

part 'get_user_state.dart';

class GetUserCubit extends Cubit<GetUserState> {
  GetUserCubit(this._getUserDataUsecase, this.sharedPreferencesService)
      : super(GetUserInitial());

  final GetUserDataUsecase _getUserDataUsecase;
  final SharedPreferencesService sharedPreferencesService;

  Future<void> getUserData() async {
    emit(GetUserLoading());

    final res = await _getUserDataUsecase.call();

    res.fold((failure) {
      emit(GetUserFailuer(errMessage: failure.message));
    }, (user) {
      emit(GetUserSuccess(user: user));
    });
  }

  Future<String> getUserName() async {
    return await sharedPreferencesService.getUserName() ?? "Person";
  }

  Future<String> getUserEmail() async {
    return await sharedPreferencesService.getUserEmail() ?? "Person@gmail.com";
  }
}
