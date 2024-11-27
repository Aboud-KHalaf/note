import 'package:flutter/material.dart';
import 'package:note/core/helpers/localization/app_localization.dart';
import 'package:note/core/helpers/providers/images_provider.dart';
import 'package:note/core/helpers/styles/spacing_h.dart';

class EmptyNotes extends StatelessWidget {
  const EmptyNotes({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding:
            EdgeInsets.only(top: (MediaQuery.sizeOf(context).height * 0.1)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SpacingHelper.widthExtender,
            Image.asset(
              ImagesProvider.noNotes,
              width: MediaQuery.sizeOf(context).width * 0.5,
            ),
            SpacingHelper.h3,
            Column(
              children: [
                Text(
                  "empty_notes".tr(context),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: theme.primaryColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "start_writing".tr(context),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: theme.hintColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
