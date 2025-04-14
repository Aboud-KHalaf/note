import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:note/core/cubits/localizations_cubit/localizations_cubit.dart';
import 'package:note/core/helpers/functions/ui_functions.dart';
import 'package:note/core/helpers/localization/app_localization.dart';
import 'package:note/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:note/features/auth/presentation/manager/get_user_cubit/get_user_cubit.dart';
import 'package:note/features/auth/presentation/views/first_view.dart';

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
    setState(() {});
  }

  void _setLange() {
    lang = BlocProvider.of<LocalizationsCubit>(context).getLang;
    setState(() {});
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
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 48,
                    color: theme.primaryColor,
                  )
                      .animate()
                      .fade(duration: const Duration(milliseconds: 300))
                      .scale(delay: const Duration(milliseconds: 100)),
                  const SizedBox(height: 16),
                  Text(
                    '${'hi'.tr(context)}!',
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      .animate()
                      .fade(duration: const Duration(milliseconds: 300))
                      .slideX(begin: -0.1, end: 0),
                  const SizedBox(height: 8),
                  Text(
                    email ?? 'Loading...',
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.hintColor,
                    ),
                  )
                      .animate()
                      .fade(duration: const Duration(milliseconds: 300))
                      .slideX(
                          begin: -0.1,
                          end: 0,
                          delay: const Duration(milliseconds: 100)),
                ],
              ),
            ),
            const DividerWithSpace(),
            _buildSectionTitle("theme".tr(context), theme),
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SwitchListTile(
                title: Text(
                  'Dark Mode',
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                value: context.read<ThemeCubit>().state.brightness ==
                    Brightness.dark,
                onChanged: (isDark) {
                  context.read<ThemeCubit>().toggleTheme();
                },
                inactiveThumbColor: theme.hintColor,
                activeColor: theme.primaryColor,
              ),
            )
                .animate()
                .fade(duration: const Duration(milliseconds: 300))
                .slideX(begin: 0.1, end: 0),
            const DividerWithSpace(),
            _buildSectionTitle("language".tr(context), theme),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLanguageButton("العربية", "ar", theme),
                  _buildLanguageButton("English", "en", theme),
                ],
              ),
            )
                .animate()
                .fade(duration: const Duration(milliseconds: 300))
                .slideX(
                    begin: 0.1,
                    end: 0,
                    delay: const Duration(milliseconds: 100)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      showWarning(
                        context: context,
                        content: "log_out_warning".tr(context),
                        type: "log_out".tr(context),
                        onDone: () async {
                          final currentContext = context;
                          final authCubit = currentContext.read<AuthCubit>();

                          await authCubit.signOut();

                          if (!currentContext.mounted) return;

                          final state = authCubit.state;
                          if (state is AuthLogOutSuccess) {
                            Navigator.pushReplacementNamed(
                                currentContext, FirstView.id);
                          } else if (state is AuthFailure) {
                            showAnimatedSnackBar(
                              currentContext,
                              Colors.red,
                              state.errMessage,
                            );
                          }
                        },
                      );
                    },
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: const Text(
                      'Sign out',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
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
            )
                .animate()
                .fade(duration: const Duration(milliseconds: 300))
                .slideY(begin: 0.1, end: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: theme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildLanguageButton(String text, String langCode, ThemeData theme) {
    final isSelected = lang == langCode;
    return ElevatedButton(
      onPressed: () {
        context.read<LocalizationsCubit>().changeLanguage(
              langCode == "ar" ? LanguageOption.ar : LanguageOption.en,
            );
        setState(() {
          lang = langCode;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? theme.primaryColor : theme.cardColor,
        foregroundColor: isSelected ? Colors.white : theme.primaryColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? theme.primaryColor : theme.dividerColor,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class DividerWithSpace extends StatelessWidget {
  const DividerWithSpace({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 16),
        Divider(
          thickness: 1,
          endIndent: 16,
          indent: 16,
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
