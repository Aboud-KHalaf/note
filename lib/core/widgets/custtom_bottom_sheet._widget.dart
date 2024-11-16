import 'package:flutter/material.dart';
import 'package:note/core/helpers/colors/app_colors.dart';

class CustomModalBottomSheet extends StatelessWidget {
  final String title;
  final List<Widget> contentWidgets;

  const CustomModalBottomSheet({
    super.key,
    required this.title,
    required this.contentWidgets,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bottomSheet,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          ...contentWidgets,
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
