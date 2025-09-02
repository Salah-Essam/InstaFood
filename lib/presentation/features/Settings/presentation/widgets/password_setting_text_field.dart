import 'package:flutter/material.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_fields.dart';
import 'package:insta_food/core/utils/app_strings.dart';
import 'package:insta_food/core/validators/app_validator_types/password_validator.dart';

class PasswordSettingTextField extends StatefulWidget {
  const PasswordSettingTextField({
    super.key,
    required this.controller,
    required this.title,
  });
  final TextEditingController controller;
  final String title;

  @override
  State<PasswordSettingTextField> createState() =>
      _PasswordSettingTextFieldState();
}

class _PasswordSettingTextFieldState extends State<PasswordSettingTextField> {
  bool obscurePassword = true;

  final PasswordAppValidator validator = PasswordAppValidator();

  final bool _showRequired = false;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,
      label: widget.title,
      hint: AppStrings.passwordHint,
      obscureText: obscurePassword,
      validator: validator,
      requiredField: true,
      showRequiredError: _showRequired && widget.controller.text.isEmpty,
      onChange: (value) {
        setState(() {
          validator.setValue(value);
        });
      },
      suffixIcon: IconButton(
        icon: Icon(
          obscurePassword ? Icons.visibility_off : Icons.visibility,
          color: AppColors.primaryOrange,
          size: 20,
        ),
        onPressed: () {
          setState(() {
            obscurePassword = !obscurePassword;
          });
        },
      ),
    );
  }
}
