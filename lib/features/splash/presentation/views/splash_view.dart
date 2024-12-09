import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:note/core/cubits/localizations_cubit/localizations_cubit.dart';
import 'package:note/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:note/features/auth/presentation/views/first_view.dart';
import 'package:note/features/auth/presentation/views/syncing_view.dart';
import 'package:note/features/folders/presentation/manager/sync_folders_cubit/sync_folders_cubit.dart';
import 'package:note/features/notes/presentation/views/home_view.dart';
import 'package:note/features/on_boarding/presentation/views/on_boarding_view.dart';

import '../../../auth/presentation/manager/get_user_cubit/get_user_cubit.dart';
import '../../../notes/presentation/manager/synce_notes_cubit/sync_notes_cubit.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late Future<void> _initialization;

  @override
  void initState() {
    super.initState();
    _initialization = _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.wait([
      BlocProvider.of<AuthCubit>(context).isUserLoggedIn(),
      BlocProvider.of<GetUserCubit>(context).getUserData(),
      BlocProvider.of<SynceNotesCubit>(context).synceNotes(),
      BlocProvider.of<SyncFoldersCubit>(context).syncFolders(),
      BlocProvider.of<LocalizationsCubit>(context).loadUserLanguage(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const SplashScreenBody();
        } else {
          return const SyncingView();
        }
      },
    );
  }
}

class SplashScreenBody extends StatelessWidget {
  const SplashScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return BlocSelector<AuthCubit, AuthState, bool>(
      selector: (state) => state is UserLoggedIn,
      builder: (context, isLoggedIn) {
        return AnimatedSplashScreen(
          duration: 1400,
          splashIconSize: 250,
          splash: Lottie.asset(
            'assets/animations/splash.json',
          ),
          nextScreen: isLoggedIn ? const HomeView() : const OnBoardingView(),
          curve: Curves.decelerate,
          splashTransition: SplashTransition.scaleTransition,
          backgroundColor: colorScheme.surface,
        );
      },
    );
  }
}
