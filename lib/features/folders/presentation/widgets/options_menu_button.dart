import 'package:flutter/material.dart';
import 'package:note/core/helpers/localization/app_localization.dart';

class OptionsMenuButton extends StatelessWidget {
  const OptionsMenuButton(
      {super.key,
      required this.onEditSelected,
      required this.ondeleteSelected});
  final Future<void> Function() onEditSelected;
  final Future<void> Function() ondeleteSelected;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return PopupMenuButton<String>(
      color: theme.cardColor,
      onSelected: (value) {
        switch (value) {
          case 'edit':
            // Perform the edit action
            onEditSelected();
            break;
          case 'delete':
            // Perform the delete action
            ondeleteSelected();
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'edit',
          child: Text('edit'.tr(context)),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Text('delete'.tr(context)),
        ),
      ],
      icon: const Icon(Icons.more_vert),
    );
  }
}
