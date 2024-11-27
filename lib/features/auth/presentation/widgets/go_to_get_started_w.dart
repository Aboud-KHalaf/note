import 'package:flutter/material.dart';
import 'package:note/core/helpers/localization/app_localization.dart';
import 'package:note/core/helpers/styles/fonts_h.dart';
import 'package:note/features/auth/presentation/views/sign_up_view.dart';

class GoToSignUp extends StatelessWidget {
  const GoToSignUp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'dont_have_an_account'.tr(context),
          style: FontsStylesHelper.textStyle15,
          textAlign: TextAlign.center,
        ),
        TextButton(
          //   style: TextButton.styleFrom(padding: EdgeInsets.zero),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(SignUpView.id);
          },
          child: Text(
            'sign_up'.tr(context),
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
