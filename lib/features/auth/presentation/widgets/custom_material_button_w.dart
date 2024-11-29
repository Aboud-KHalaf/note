import 'package:flutter/material.dart';
import 'package:note/core/helpers/styles/fonts_h.dart';

class CustomMaterialButton extends StatelessWidget {
  const CustomMaterialButton({
    super.key,
    required this.text,
    required this.color,
    required this.onPressed,
  });

  final String text;
  final Color color;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: double.infinity,
      height: 50,
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: FontsStylesHelper.textStyle16.copyWith(
          color: (color == Colors.white) ? Colors.black : null,
        ),
      ),
    );
  }
}
