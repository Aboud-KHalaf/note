import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/core/helpers/localization/app_localization.dart';
import 'package:note/core/utils/logger.dart';

import '../../services/shared_preferences_services.dart';

part 'localizations_state.dart';

class LocalizationsCubit extends Cubit<LocalizationsState> {
  final SharedPreferencesService _sharedPreferencesService;

  LocalizationsCubit(this._sharedPreferencesService)
      : super(LocalizationsInitial());

  String _lang = "en";
  String get getLang => _lang;

  Future<void> loadUserLanguage() async {
    try {
      final String savedLangCode =
          await _sharedPreferencesService.getUserLang();
      _lang = savedLangCode;
      Log.info("Loaded user language: $savedLangCode");
      emit(LanguageLoaded(Locale(savedLangCode)));
    } catch (e) {
      Log.error("Error loading language: $e");
      emit(LocalizationsError("Failed to load user language."));
    }
  }

  Future<void> changeLanguage(LanguageOption lang) async {
    try {
      await _sharedPreferencesService.saveUserLang(language: lang);
      Log.info("Language changed to: $lang");
      _lang = lang.code;
      emit(LanguageLoaded(Locale(lang.code)));
    } catch (e) {
      Log.error("Error changing language: $e");
      emit(LocalizationsError("Failed to change language."));
    }
  }
}
