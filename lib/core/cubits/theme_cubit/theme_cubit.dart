import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/core/services/shared_preferences_services.dart';

import '../../helpers/colors/themes.dart';

class ThemeCubit extends Cubit<ThemeData> {
  final SharedPreferencesService _prefs;

  ThemeCubit(this._prefs) : super(lightTheme) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final isDarkMode = await _prefs.getThemeMode();
    emit(isDarkMode ? darkTheme : lightTheme);
  }

  Future<void> toggleTheme() async {
    final isDarkMode = state.brightness == Brightness.light;
    await _prefs.saveThemeMode(isDarkMode);
    emit(isDarkMode ? darkTheme : lightTheme);
  }
}
