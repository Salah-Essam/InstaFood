import 'package:flutter/material.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';

class AppTheme {
  static final ThemeData theme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    fontFamily: "LeagueSpartan",
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.primary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: AppColors.yellow2,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      hintStyle: AppTextStyles.header,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.yellow2),
        borderRadius: BorderRadius.circular(16),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.yellow2),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.yellow2),
        borderRadius: BorderRadius.circular(16),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(width: 1.5, color: Colors.red),
      ),
      suffixIconColor: Colors.grey,
      prefixIconColor: Colors.grey,
    ),
  );
}
