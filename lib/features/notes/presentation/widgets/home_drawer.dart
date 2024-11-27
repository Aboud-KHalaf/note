import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/core/cubits/localizations_cubit/localizations_cubit.dart';
import 'package:note/core/helpers/localization/app_localization.dart';
import 'package:note/features/auth/presentation/manager/get_user_cubit/get_user_cubit.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  late String name, email, lang;

  @override
  void initState() {
    super.initState();
    _setNameAndEmail();
    _setLange();
  }

  Future<void> _setNameAndEmail() async {
    name = await BlocProvider.of<GetUserCubit>(context).getUserName();
    if (mounted) {
      email = await BlocProvider.of<GetUserCubit>(context).getUserEmail();
    }
  }

  void _setLange() {
    lang = BlocProvider.of<LocalizationsCubit>(context).getLang;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi, $name!', // Personal greeting
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    email,
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Welcome back!',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Theme",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 10),

            SwitchListTile(
              title: const Text('Dark Mode'),
              value: true,
              onChanged: (isDark) {},
              inactiveThumbColor: theme.hintColor,
              activeColor: theme.hintColor,
            ),

            // Language Selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Language",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<LocalizationsCubit>()
                          .changeLanguage(LanguageOption.ar);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          (lang == "ar") ? theme.cardColor : theme.hintColor,
                    ),
                    child: const Text("العربية"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<LocalizationsCubit>()
                          .changeLanguage(LanguageOption.en);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          (lang == "en") ? theme.cardColor : theme.hintColor,
                    ),
                    child: const Text("English"),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Footer
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "App Version: 1.0.0",
                style: TextStyle(
                  fontSize: 12,
                  color: theme.hintColor.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
