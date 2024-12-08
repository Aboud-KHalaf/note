import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/core/cubits/localizations_cubit/localizations_cubit.dart';
import 'package:note/core/helpers/functions/ui_functions.dart';
import 'package:note/core/helpers/localization/app_localization.dart';
import 'package:note/features/auth/presentation/manager/get_user_cubit/get_user_cubit.dart';

import '../../../../core/cubits/theme_cubit/theme_cubit.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  String? email, lang;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _setEmail());
    _setLange();
  }

  Future<void> _setEmail() async {
    email = await BlocProvider.of<GetUserCubit>(context).getUserEmail();
    setState(() {}); // Update UI when email is fetched
  }

  void _setLange() {
    lang = BlocProvider.of<LocalizationsCubit>(context).getLang;
    setState(() {}); // Update UI for initial language
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
                    '${'hi'.tr(context)}!',
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    email ??
                        'Loading...', // Show "Loading..." until email is ready
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            const DividerWithSpace(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "theme".tr(context),
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
              value: context.read<ThemeCubit>().state.brightness ==
                  Brightness.dark,
              onChanged: (isDark) {
                context.read<ThemeCubit>().toggleTheme();
              },
              inactiveThumbColor: theme.hintColor,
              activeColor: theme.hintColor,
            ),
            const DividerWithSpace(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "language".tr(context),
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
                      setState(() {
                        lang = "ar";
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          (lang != "ar") ? theme.cardColor : theme.hintColor,
                    ),
                    child: const Text("العربية"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<LocalizationsCubit>()
                          .changeLanguage(LanguageOption.en);
                      setState(() {
                        lang = "en";
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          (lang != "en") ? theme.cardColor : theme.hintColor,
                    ),
                    child: const Text("English"),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      showWarning(
                          context: context,
                          content: "log_out_warning".tr(context),
                          type: "log_out".tr(context),
                          onDone: () async {});
                    },
                    child: const Text(
                      'Sign out',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  Text(
                    "App Version: 1.0.0",
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.hintColor.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DividerWithSpace extends StatelessWidget {
  const DividerWithSpace({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 10),
        Divider(
          thickness: 1,
          endIndent: 30,
          indent: 30,
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
