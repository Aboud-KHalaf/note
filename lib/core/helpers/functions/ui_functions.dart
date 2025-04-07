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

      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 300),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Opacity(
              opacity: value,
              child: AlertDialog(
                title: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: theme.primaryColor,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "warning".tr(context),
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                content: Text(
                  content,
                  style: TextStyle(
                    color: theme.hintColor,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: theme.primaryColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "cancel".tr(context),
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await onDone();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                      type,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
