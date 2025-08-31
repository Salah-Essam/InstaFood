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
  });
  final TextEditingController? controller;
  final Function(String)? onChange;
  final TextInputType? type;
  final bool? isObscure;
  final TextStyle? style;
  final String? labelText;
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? errorText;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines ?? 1,
      maxLength: maxLength,
      controller: controller,
      onChanged: onChange,

      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16, // يمين وشمال
          vertical: 12, // فوق وتحت
        ),
        labelText: labelText,
        hintText: hint,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        errorText: errorText,
      ),
      keyboardType: type,
      obscureText: isObscure ?? false,
      style: style,
      textInputAction: textInputAction,
    );
  }
}
