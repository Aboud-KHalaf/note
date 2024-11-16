import 'package:flutter/material.dart';
import 'package:note/core/helpers/colors/app_colors.dart';
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
  });

  final String hintText;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final void Function(String)? onFieldSubmitted;
  final Icon? suffixIcon;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
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
          prefixIconColor: AppColors.primary,
          hintText: hintText,
          hintStyle: FontsStylesHelper.textStyle13,
          filled: true,
          fillColor: AppColors.background,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 1,
              color: AppColors.primary,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AppColors.primary,
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
