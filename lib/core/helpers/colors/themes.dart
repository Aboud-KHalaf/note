import 'package:flutter/material.dart';
import 'package:note/core/helpers/colors/app_colors.dart';

final ThemeData lightTheme = ThemeData(
  fontFamily: 'Rubik',
  brightness: Brightness.light,
  primaryColor: AppColors.primary,
  hintColor: AppColors.secondary,
  cardColor: AppColors.lightCardColor,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.lightBackground,
    surfaceTintColor: AppColors.lightBackground,
    elevation: 0,
  ),
);

final ThemeData darkTheme = ThemeData(
  fontFamily: 'Rubik',
  brightness: Brightness.dark,
  primaryColor: Colors.grey[900],
  hintColor: Colors.blueAccent,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.background,
    surfaceTintColor: AppColors.background,
    elevation: 0,
  ),
);
