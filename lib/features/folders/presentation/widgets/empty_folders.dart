import 'package:flutter/material.dart';
import 'package:note/core/helpers/localization/app_localization.dart';
import 'package:note/core/helpers/providers/images_provider.dart';
import 'package:note/core/helpers/styles/spacing_h.dart';

class EmptyFolders extends StatelessWidget {
  const EmptyFolders({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 36.0),
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(top: (MediaQuery.sizeOf(context).height * 0.1)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SpacingHelper.widthExtender,
              Image.asset(
                ImagesProvider.noFolders,
                width: MediaQuery.sizeOf(context).width * 0.5,
              ),
              SpacingHelper.h3,
              Text(
                'emtpy_folders'.tr(context),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
