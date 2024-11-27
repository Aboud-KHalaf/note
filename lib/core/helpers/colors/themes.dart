import 'package:flutter/material.dart';
import 'package:note/core/helpers/colors/app_colors.dart';

final ThemeData lightTheme = ThemeData(
  fontFamily: 'Rubik',
  brightness: Brightness.light,
  primaryColor: AppColors.lightPrimary,
  hintColor: AppColors.lightSecondary,
  cardColor: AppColors.lightCardColor,
  scaffoldBackgroundColor: AppColors.lightBackground,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.lightBackground,
    surfaceTintColor: AppColors.lightBackground,
    elevation: 0,
  ),
  bottomSheetTheme: const BottomSheetThemeData(),
);

final ThemeData darkTheme = ThemeData(
  fontFamily: 'Rubik',
  brightness: Brightness.dark,
  primaryColor: AppColors.darkPrimary,
  hintColor: AppColors.darkSecondary,
  cardColor: AppColors.darkCardColor,
  scaffoldBackgroundColor: AppColors.darkBackground,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.darkBackground,
    surfaceTintColor: AppColors.darkBackground,
    elevation: 0,
  ),
  bottomSheetTheme: const BottomSheetThemeData(),
);
