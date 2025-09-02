import 'package:flutter/material.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';

class AppTheme {
  static final ThemeData theme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryOrange),
    fontFamily: "LeagueSpartan",
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.primaryOrange,
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: AppColors.lightYellow,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      hintStyle: AppTextStyles.header,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.lightYellow),
        borderRadius: BorderRadius.circular(16),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.lightYellow),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.lightYellow),
        borderRadius: BorderRadius.circular(16),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(width: 1.5, color: Colors.red),
      ),
      suffixIconColor: Colors.grey,
      prefixIconColor: Colors.grey,
    ),
    // sliderTheme: SliderThemeData(
    //   activeTrackColor: AppColors.primaryOrange,
    //   inactiveTrackColor: AppColors.grey.withOpacity(0.3),
    //   trackHeight: 7.749244689941406,

    //   thumbColor: AppColors.primaryOrange,
    //   thumbShape: RoundSliderThumbShape(
    //     enabledThumbRadius: 10.0, // Size of the thumb
    //     disabledThumbRadius: 8.0,
    //     elevation: 2.0,
    //   ),
    // ),
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.primaryOrange,
      inactiveTrackColor: AppColors.grey.withAlpha(76),
      trackHeight: 7.75,
      // Thumb properties
      thumbColor: AppColors.primaryOrange,
      thumbShape: RoundSliderThumbShape(
        enabledThumbRadius: 12.0,
        disabledThumbRadius: 10.0,
        elevation: 2.0,
      ),

      // Overlay properties
      overlayColor: AppColors.white,
      overlayShape: RoundSliderOverlayShape(overlayRadius: 16.0),

      // Value indicator properties
      valueIndicatorTextStyle: AppTextStyles.small,

      // For keypoints/divisions
      activeTickMarkColor: AppColors.primaryOrange,
      inactiveTickMarkColor: AppColors.grey.withAlpha(127),
      tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 2.0),

      // Optional: Show always the value indicator
      showValueIndicator: ShowValueIndicator.always,
    ),
  );
}
