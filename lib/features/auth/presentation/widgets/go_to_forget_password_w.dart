import 'package:flutter/material.dart';
import 'package:note/core/helpers/localization/app_localization.dart';
import 'package:note/core/helpers/styles/fonts_h.dart';
import 'package:note/features/auth/presentation/views/forget_password_view.dart';

class GoToForgetPassword extends StatelessWidget {
  const GoToForgetPassword({
    super.key,
    required this.colorScheme,
  });

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pushNamed(ForgetPasswordView.id);
      },
      child: Text(
        'forgot_password'.tr(context),
        style: FontsStylesHelper.textStyle15.copyWith(
          color: colorScheme.primary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
