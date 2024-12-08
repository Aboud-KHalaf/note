import 'package:flutter/material.dart';
import 'package:note/core/helpers/styles/fonts_h.dart';

class CustomTextFormFieldWidget extends StatelessWidget {
  const CustomTextFormFieldWidget({
    super.key,
    required this.hintText,
    this.suffixIcon,
    required this.controller,
    this.obscureText = false,
    this.validator,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.onChanged,
  });

  final String hintText;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final void Function(String)? onFieldSubmitted;
  final Icon? suffixIcon;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return SizedBox(
      child: TextFormField(
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        textInputAction: textInputAction,
        focusNode: focusNode,
        validator: validator,
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          errorMaxLines: 1,
          errorStyle: const TextStyle(fontSize: 10),
          prefixIcon: suffixIcon,
          prefixIconColor: theme.primaryColor,
          hintText: hintText,
          hintStyle: FontsStylesHelper.textStyle13,
          filled: true,
          fillColor: theme.scaffoldBackgroundColor,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: theme.primaryColor,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: theme.primaryColor,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
