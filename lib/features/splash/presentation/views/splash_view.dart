import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:note/core/cubits/localizations_cubit/localizations_cubit.dart';
import 'package:note/core/services/network_services.dart';
import 'package:note/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
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
  final _internetConnectivity = InternetConnectivityImpl();

  @override
  void initState() {
    super.initState();
    _initialization = _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      final authCubit = context.read<AuthCubit>();
      final getUserCubit = context.read<GetUserCubit>();
      final syncNotesCubit = context.read<SynceNotesCubit>();
      final syncFoldersCubit = context.read<SyncFoldersCubit>();
      final localizationsCubit = context.read<LocalizationsCubit>();

      // First check auth state
      await authCubit.isUserLoggedIn();

      if (authCubit.state is UserLoggedIn) {
        // Load user data first
        await getUserCubit.getUserData();

        // Check internet connectivity
        final isConnected = await _internetConnectivity.isConnected();
        if (isConnected) {
          // If connected, perform sync operations
          await _performSyncOperations(syncNotesCubit, syncFoldersCubit);
        }
      }

      // Load language preferences last
      await localizationsCubit.loadUserLanguage();
    } catch (e) {
      debugPrint('Error during initialization: $e');
    }
  }

  Future<void> _performSyncOperations(
    SynceNotesCubit syncNotesCubit,
    SyncFoldersCubit syncFoldersCubit,
  ) async {
    try {
      // Perform sync operations in parallel
      await Future.wait([
        syncNotesCubit.synceNotes(),
        syncFoldersCubit.syncFolders(),
      ]);
    } catch (e) {
      debugPrint('Error during sync: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const SplashScreenBody();
          }
          return const SplashScreenBody();
        } else {
          return const SplashScreenBody();
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
          duration: 2000, // Increased duration to ensure smooth transition
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
