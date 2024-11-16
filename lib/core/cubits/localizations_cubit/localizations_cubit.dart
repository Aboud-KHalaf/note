import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/core/helpers/localization/app_localization.dart';
import 'package:note/core/utils/logger.dart';

import '../../services/shared_preferences_services.dart';

part 'localizations_state.dart';

class LocalizationsCubit extends Cubit<LocalizationsState> {
  LocalizationsCubit(this.sharedPreferencesService)
      : super(LocalizationsInitial());
  final SharedPreferencesService sharedPreferencesService;

  late String languageCode;

  Future<void> saveUserLang(LanguageOption lang) async {
    sharedPreferencesService.saveUserLang(language: lang);
  }

  Future<void> getLang() async {
    languageCode = await sharedPreferencesService.getUserLang();
    Log.info("get user lang : $languageCode");
  }
}
