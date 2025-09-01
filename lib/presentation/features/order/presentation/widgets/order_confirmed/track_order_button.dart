import 'package:flutter/material.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/utils/app_strings.dart';

class TrackOrderButton extends StatelessWidget {
  const TrackOrderButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10),
        child: Text(
          AppStrings.trackMyOrder,
          style: AppTextStyles.mediumText.copyWith(
            color: AppColors.primaryOrange,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
