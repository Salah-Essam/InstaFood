import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  final String? label;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final TextStyle? textStyle;
  final double? width;
  final double? height;
  final double borderRadius;
  final Widget? child;
  final ButtonStyle? style;
  final BorderSide? border;
  final double elevation;

  const AppButton({
    super.key,
    this.label,
    required this.onPressed,
    this.backgroundColor = const Color(0xFFE95322),
    this.textStyle,
    this.width,
    this.height,
    this.borderRadius = 12,
    this.child,
    this.style,
    this.border,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 1.sw,
      height: height ?? 48.h,
      child: ElevatedButton(
        style: style ?? ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular((borderRadius).r),
            side: border ?? BorderSide.none,
          ),
          elevation: elevation,
        ),
        onPressed: onPressed,
        child: child ?? Text(label ?? "", style: textStyle),
      ),
    );
  }
}
