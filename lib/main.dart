import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:note/core/helpers/colors/app_colors.dart';
import 'package:note/core/helpers/localization/app_localization.dart';
import 'package:note/features/splash/presentation/views/splash_view.dart';

import 'core/helpers/data/lists.dart';
import 'core/helpers/data/maps.dart';
import 'core/services/services_locator_imports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initApp();
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notes App',
        supportedLocales: const [
          Locale('en'),
          Locale('ar'),
        ],
        theme: ThemeData(
          fontFamily: 'Rubik',
          textTheme: const TextTheme(
            bodyLarge: TextStyle(fontSize: 16),
            bodyMedium: TextStyle(fontSize: 14),
            titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.background,
            surfaceTintColor: AppColors.background,
            elevation: 0,
          ),
          brightness: Brightness.dark,
        ),
        locale: const Locale('ar'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: localeResolutionCallback,
        home: const SplashView(),
        routes: appRoutes,
      ),
    );
  }
}
