import 'package:flutter/material.dart';
import 'package:note/core/helpers/colors/app_colors.dart';

class OptionsMenuButton extends StatelessWidget {
  const OptionsMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: AppColors.cardColor,
      onSelected: (value) {
        switch (value) {
          case 'update':
            // Perform the update action
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Update option selected')));
            break;
          case 'delete':
            // Perform the delete action
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Delete option selected')));
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'update',
          child: Text('Update'),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: Text('Delete'),
        ),
      ],
      icon: const Icon(Icons.more_vert),
    );
  }
}
