import 'package:flutter/material.dart';
import 'package:note/core/helpers/localization/app_localization.dart';
import 'package:note/core/helpers/styles/fonts_h.dart';
import 'package:note/features/auth/presentation/views/sign_in_view.dart';

class GoToSignIn extends StatelessWidget {
  const GoToSignIn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'already_have_an_account'.tr(context),
          style: FontsStylesHelper.textStyle15,
          textAlign: TextAlign.center,
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(SignInView.id);
          },
          child: Text(
            'sign_in'.tr(context),
            style: FontsStylesHelper.textStyle15.copyWith(
              color: theme.primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
