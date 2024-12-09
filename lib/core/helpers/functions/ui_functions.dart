import 'package:flutter/material.dart';
import 'package:note/core/helpers/localization/app_localization.dart';
import 'package:note/features/folders/domain/entities/folder_entity.dart';

import '../../../features/folders/presentation/widgets/add_folder_dalog_content_widget.dart';
import '../../widgets/custtom_bottom_sheet._widget.dart';

Widget buildLoadingIndicator(Color color) {
  return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: color,
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
  ThemeData theme = Theme.of(context);

  showModalBottomSheet(
      showDragHandle: true,
      backgroundColor: theme.cardColor,
      context: context,
      builder: (BuildContext context) => child);
}

Future<dynamic> showAddFolderDialog(
    {required BuildContext context, FolderEntity? folderEntity}) {
  ThemeData theme = Theme.of(context);

  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            backgroundColor: theme.cardColor,
            content: AddFolderDialogContentWidget(folderEntity: folderEntity),
          ));
}

bool isArbic(firstChar) {
  final bool isArab = RegExp(
          r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]')
      .hasMatch(firstChar);
  return isArab;
}

void showWarning({
  required BuildContext context,
  required String content,
  required String type,
  required Future<void> Function() onDone,
}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      ThemeData theme = Theme.of(context);

      return AlertDialog(
        title: Text("warning".tr(context)),
        content: Text(content),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: theme.primaryColor, // Border color
            width: 0.3, // Border width
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("cancel".tr(context)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await onDone();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(type),
          ),
        ],
      );
    },
  );
}

String formatDateTime(DateTime dateTime, {String separator = '-'}) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');

  final year = dateTime.year;
  final month = twoDigits(dateTime.month);
  final day = twoDigits(dateTime.day);

  return "$year$separator$month$separator$day";
}
