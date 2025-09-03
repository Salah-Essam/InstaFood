import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle get title => TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
  static TextStyle get dialogTitle => TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle get body => TextStyle(
    fontSize: 13.sp,
    height: 1.4,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle get button => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static TextStyle get skipButton => TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryOrange,
  );
  static TextStyle get buttonOrangeText => TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryOrange,
  );
  static TextStyle get buttonWhiteText => TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  // ===========================
  static TextStyle get greeting => TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 30.sp,
    color: AppColors.textLight,
  );

  static TextStyle get greetingDialog => TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 13.sp,
    color: AppColors.primaryOrange,
  );

  static TextStyle dialogGreetingDialogeOrange = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 24,
    color: AppColors.primaryOrange,
  );
  static TextStyle dialogGreetingDialogeWhite = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 24,
    color: AppColors.white,
  );
  static TextStyle search = TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 12,
    color: AppColors.textSecondary,
  );
  static TextStyle searchSetting = TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 20,
    color: AppColors.textSecondary,
  );

  static TextStyle get small => TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12.sp,
    color: AppColors.textDarkBrown,
  );

  static TextStyle get header => TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 20.sp,
    color: AppColors.textDarkBrown,
  );

  static TextStyle get ad => TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14.sp,
    color: AppColors.textLight,
  );

  static TextStyle get price => TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 11.sp,
    color: AppColors.textLight,
  );

  static TextStyle pageTitle = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 28,
    color: AppColors.textLight,
  );
  static TextStyle itemPagePrice = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 24,
    color: AppColors.primaryOrange,
  );
  static TextStyle mediumText = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: AppColors.textDarkBrown,
  );

  static TextStyle get subCatagoryButton => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryOrange,
  );

  static TextStyle get login => TextStyle(
    color: AppColors.white,
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
  );
  static TextStyle get forgetPassword => TextStyle(
    color: AppColors.primaryOrange,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
  );

  // ========================= Black Fonts =========================

  static final TextStyle fontBlackSmall = TextStyle(
    color: AppColors.textDarkBrown,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle fontBlackSmallBold = TextStyle(
    color: AppColors.textDarkBrown,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );
  static final TextStyle fontBlackMed = TextStyle(
    color: AppColors.textDarkBrown,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle fontBlackMedBold = TextStyle(
    color: AppColors.textDarkBrown,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  static final TextStyle fontBlackLarge = TextStyle(
    color: AppColors.textDarkBrown,
    fontSize: 24,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle fontBlackLargeBold = TextStyle(
    color: AppColors.textDarkBrown,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  // ========================= White Fonts =========================

  static final TextStyle fontWhiteSmall = TextStyle(
    color: AppColors.textLight,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle fontWhiteSmallBold = TextStyle(
    color: AppColors.textLight,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );
  static final TextStyle fontWhiteMed = TextStyle(
    color: AppColors.textLight,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle fontWhiteMedBold = TextStyle(
    color: AppColors.textLight,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  static final TextStyle fontWhiteMediumBold = TextStyle(
    color: AppColors.textLight,
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );
  static final TextStyle fontWhiteLarge = TextStyle(
    color: AppColors.textLight,
    fontSize: 24,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle fontWhiteLargeBold = TextStyle(
    color: AppColors.textLight,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  // ========================= AppColors Fonts =========================

  static final TextStyle fontPrimarySmall = TextStyle(
    color: AppColors.primaryOrange,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle fontPrimarySmallBold = TextStyle(
    color: AppColors.primaryOrange,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );
  static final TextStyle fontPrimaryMediumRagular = TextStyle(
    color: AppColors.primaryOrange,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle fontPrimaryHeaderRagular = TextStyle(
    color: AppColors.primaryOrange,
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle fontSecondarysmallCrossed = TextStyle(
    color: AppColors.primaryYellow,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.lineThrough,
    decorationColor: AppColors.primaryOrange,
    decorationThickness: 2.0,
  );
}
