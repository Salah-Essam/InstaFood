import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          maxLines: maxLines ?? 1,
          controller: controller,
          onChanged: onChange,
          decoration: InputDecoration(
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
        ),
      ],
    );
  }
}
