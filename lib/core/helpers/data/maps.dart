import 'package:flutter/widgets.dart';
import 'package:note/features/auth/presentation/views/syncing_view.dart';
import 'package:note/features/search/presentation/views/search_view.dart';

import '../../../features/auth/presentation/views/first_view.dart';
import '../../../features/auth/presentation/views/forget_password_view.dart';
import '../../../features/auth/presentation/views/sign_in_view.dart';
import '../../../features/auth/presentation/views/sign_up_view.dart';
import '../../../features/notes/presentation/views/home_view.dart';
import '../../../features/notes/presentation/views/note_detail_view.dart';

Map<String, WidgetBuilder> appRoutes = {
  HomeView.id: (_) => const HomeView(),
  FirstView.id: (_) => const FirstView(),
  SignInView.id: (_) => const SignInView(),
  SignUpView.id: (_) => const SignUpView(),
  ForgetPasswordView.id: (_) => const ForgetPasswordView(),
  NoteDetailScreen.id: (_) => const NoteDetailScreen(),
  SyncingView.id: (_) => const SyncingView(),
  SearchView.id: (_) => const SearchView(),
};
