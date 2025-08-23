import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'colors.dart';

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
    color: Colors.white,
  );
  
  static TextStyle get skipButton => TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );
}