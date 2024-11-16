import 'package:flutter/material.dart';
import 'package:note/core/helpers/localization/app_localization.dart';

class TitleField extends StatelessWidget {
  final TextEditingController controller;
  final TextDirection direction;
  final void Function(String)? onChanged;

  const TitleField(
      {super.key,
      required this.controller,
      required this.direction,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      textDirection: direction,
      controller: controller,
      style: const TextStyle(
        fontSize: 24.0,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: "title".tr(context),
        border: InputBorder.none,
      ),
      autofocus: false,
      maxLines: 1,
    );
  }
}

class ContentField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final TextDirection direction;

  const ContentField(
      {super.key,
      required this.controller,
      this.onChanged,
      required this.direction});

  @override
  Widget build(BuildContext context) {
    return TextField(
      textDirection: direction,
      controller: controller,
      style: const TextStyle(
        fontSize: 18.0,
      ),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: "note".tr(context),
        border: InputBorder.none, // Remove underline
      ),
      autofocus: false,
      maxLines: null, // Allow multi-line input
      expands: false, // Ensures the text field takes up remaining space
      keyboardType: TextInputType.multiline,
    );
  }
}
