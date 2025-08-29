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
  static TextStyle get greeting => TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 30.sp,
    color: AppColors.fontWhite,
  );
  
  static TextStyle get greetingDialog => TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 13.sp,
    color: AppColors.primary,
  );
  
  static TextStyle get search => TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 12.sp,
    color: AppColors.grey,
  );
  
  static TextStyle get small => TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12.sp,
    color: AppColors.darktext,
  );
  
  static TextStyle get header => TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 20.sp,
    color: AppColors.darktext,
  );
  
  static TextStyle get ad => TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16.sp,
    color: AppColors.fontWhite,
  );
  
  static TextStyle get price => TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 11.sp,
    color: AppColors.fontWhite,
  );
  
  static TextStyle get login => TextStyle(
    color: AppColors.white,
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
  );
  static TextStyle get forgetPassword => TextStyle(
    color: AppColors.primary,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
  );
}
