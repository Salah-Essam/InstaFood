import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/core/utils/app_validators.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.controller,
    this.onChange,
    this.hint,
    this.label,
    this.suffixIcon,
    this.prefixIcon,
    this.style,
    this.keyboardType,
    this.isReadOnly,
    this.obscureText,
    this.width,
    this.height,
    this.validator,
    this.inputFormatters,
    this.showPasswordToggle = false,
  this.requiredField = false,
  this.showRequiredError = false,
  });
  final TextEditingController controller;
  final Function(String)? onChange;
  final String? hint;
  final String? label;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextStyle? style;
  final TextInputType? keyboardType;
  final bool? isReadOnly;
  final bool? obscureText;
  final double? width;
  final double? height;
  final AppValidator? validator;
  final List<TextInputFormatter>? inputFormatters;
  final bool showPasswordToggle;
  final bool requiredField;
  final bool showRequiredError;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.small.copyWith(
              color: AppColors.brown,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],
        
        // Text Field Container
        Container(
          height: widget.height ?? 56,
          width: widget.width ?? double.infinity,
          decoration: BoxDecoration(
            color: AppColors.yellow2,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _requiredError ? AppColors.error : Colors.transparent,
              width: 1.2,
            ),
          ),
          child: TextFormField(
            controller: widget.controller,
            onChanged: (value) {
              widget.onChange?.call(value);
              setState(() {});
            },
            inputFormatters: widget.inputFormatters,
            style: widget.style ?? AppTextStyles.body.copyWith(
              color: AppColors.darkBrown,
              fontSize: 16,
            ),
            keyboardType: widget.keyboardType ?? TextInputType.text,
            readOnly: widget.isReadOnly ?? false,
            obscureText: widget.showPasswordToggle ? _obscureText : (widget.obscureText ?? false),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: AppTextStyles.body.copyWith(
                color: AppColors.darkBrown,
                fontSize: 16,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.showPasswordToggle 
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  )
                : widget.suffixIcon,
            ),
          ),
        ),
        
        // Validation Messages
        if (widget.validator != null) getValidationHints(),
        if (_requiredError)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              'This field is required',
              style: AppTextStyles.small.copyWith(
                color: AppColors.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  bool get _requiredError =>
      widget.requiredField && widget.showRequiredError && widget.controller.text.isEmpty;

  Widget getValidationHints() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ...widget.validator!.reasons.map(
          (e) => Column(
            children: [
              const SizedBox(height: 5),
              Text(
                e, 
                style: AppTextStyles.small.copyWith(
                  color: AppColors.error, 
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}