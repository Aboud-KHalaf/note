import 'package:flutter/material.dart';
import 'package:note/core/helpers/localization/app_localization.dart';
import 'package:note/core/helpers/providers/images_provider.dart';
import 'package:note/core/helpers/styles/fonts_h.dart';
import 'package:note/core/helpers/styles/spacing_h.dart';
import 'package:note/features/auth/presentation/views/sign_in_view.dart';
import 'package:note/features/auth/presentation/views/sign_up_view.dart';
import 'package:note/features/auth/presentation/widgets/custom_material_button_w.dart';

class FirstView extends StatelessWidget {
  const FirstView({super.key});

  static String id = "/first";

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: FirstViewBody(),
    );
  }
}

//

class FirstViewBody extends StatelessWidget {
  const FirstViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            ImagesProvider.appIcon,
          ),
        ),
      ),
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.black.withOpacity(1),
              Colors.black.withOpacity(0.3),
              Colors.white.withOpacity(0.0),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              'Notes',
              style: FontsStylesHelper.textStyle40,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'welcome_text'.tr(context),
                style: FontsStylesHelper.textStyle24,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomMaterialButton(
                text: "get_started".tr(context),
                color: theme.primaryColor,
                onPressed: () {
                  Navigator.of(context).pushNamed(SignUpView.id);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomMaterialButton(
                text: "sign_in".tr(context),
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context).pushNamed(SignInView.id);
                },
              ),
            ),
            SpacingHelper.h6
          ],
        ),
      ),
    );
  }
}
