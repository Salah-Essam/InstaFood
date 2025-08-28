import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle get title => TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.title,
  );

  static TextStyle get body => TextStyle(
    fontSize: 13.sp,
    height: 1.4,
    fontWeight: FontWeight.w400,
    color: AppColors.body,
  );

  static TextStyle get button => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static TextStyle get skipButton => TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );
  // ===========================
  static final TextStyle greeting = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 30,
    color: AppColors.fontWhite,
  );
  static TextStyle greetingDialoge = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 13,
    color: AppColors.primary,
  );
  static TextStyle search = TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 12,
    color: AppColors.body,
  );
  static TextStyle small = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: AppColors.darktext,
  );
  static TextStyle header = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 20,
    color: AppColors.darktext,
  );
  static TextStyle ad = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: AppColors.fontWhite,
  );
  static TextStyle price = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 11,
    color: AppColors.fontWhite,
  );
}
