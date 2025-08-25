import 'package:flutter/material.dart';
import 'package:insta_food/core/theme/app_colors.dart';

class AppTheme {
  static final ThemeData theme = ThemeData(
    useMaterial3: true,
    fontFamily: "LeagueSpartan",
    scaffoldBackgroundColor: AppColors.statusBar,
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.primary,
    ),
  );
}
