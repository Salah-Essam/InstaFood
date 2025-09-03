// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class AppTextFieldDrawer extends StatelessWidget {
  const AppTextFieldDrawer({
    super.key,
    required this.controller,
    required this.onChange,
    this.type,
    this.isObscure,
    this.style,
    this.labelText,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.errorText,
    this.textInputAction,
    this.maxLines,
    this.maxLength,
    this.height,
    this.backgroundColor,
    this.hintStyle,
  });
  final TextEditingController? controller;
  final Function(String)? onChange;
  final TextInputType? type;
  final bool? isObscure;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final String? labelText;
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? errorText;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? maxLength;
  final int? height;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final textField = TextFormField(
      cursorHeight: (height ?? 36) - 12,
      maxLines: maxLines,
      maxLength: maxLength,
      controller: controller,
      onChanged: onChange,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        labelText: labelText,
        hintText: hint,
        hintStyle: hintStyle,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        errorText: errorText,
        counterText: "",
        fillColor:
            backgroundColor ?? Theme.of(context).inputDecorationTheme.fillColor,
        filled: true,
      ),
      keyboardType: type,
      obscureText: isObscure ?? false,
      style: style,
      textInputAction: textInputAction,
    );
    if (height != null) {
      return SizedBox(height: height!.toDouble(), child: textField);
    }
    return textField;
  }
}
