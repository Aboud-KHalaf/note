import 'package:flutter/material.dart';
import 'package:note/core/helpers/colors/app_colors.dart';

import '../../../features/folders/presentation/widgets/add_folder_dalog_content_widget.dart';
import '../../widgets/custtom_bottom_sheet._widget.dart';

Widget buildLoadingIndicator() {
  return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: AppColors.primary,
      ),
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ));
}

void showAnimatedSnackBar(BuildContext context, Color color, String text) {
  final snackBar = SnackBar(
    content: Text(text),
    behavior: SnackBarBehavior.floating,
    backgroundColor: color,
    duration: const Duration(seconds: 2),
    margin: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
    animation: CurvedAnimation(
      parent: AnimationController(
        vsync: Scaffold.of(context),
        duration: const Duration(milliseconds: 500),
      ),
      curve: Curves.easeInOut,
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void customShowModelBottomSheetMethod(
    {required BuildContext context, required CustomModalBottomSheet child}) {
  showModalBottomSheet(
      showDragHandle: true,
      backgroundColor: AppColors.bottomSheet,
      context: context,
      builder: (BuildContext context) => child);
}

Future<dynamic> showAddFolderDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) => const AlertDialog(
            backgroundColor: AppColors.cardColor,
            content: AddFolderDialogContentWidget(),
          ));
}

bool isArbic(firstChar) {
  final bool isArab = RegExp(
          r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]')
      .hasMatch(firstChar);
  return isArab;
}
