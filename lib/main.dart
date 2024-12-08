import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:note/core/cubits/localizations_cubit/localizations_cubit.dart';
import 'package:note/core/cubits/theme_cubit/theme_cubit.dart';
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
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, theme) {
          return BlocBuilder<LocalizationsCubit, LocalizationsState>(
            builder: (context, state) {
              Locale locale = const Locale('en');
              if (state is LanguageLoaded) {
                locale = state.locale;
              }
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Notes App',
                supportedLocales: const [
                  Locale('en'),
                  Locale('ar'),
                ],
                theme: theme,
                locale: locale,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                localeResolutionCallback: localeResolutionCallback,
                home: const SplashView(),
                routes: appRoutes,
              );
            },
          );
        },
      ),
    );
  }
}
