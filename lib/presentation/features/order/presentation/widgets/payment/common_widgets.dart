import 'package:flutter/material.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';

class LightDivider extends StatelessWidget {
  const LightDivider({super.key});
  @override
  Widget build(BuildContext context) =>
      const Divider(color: AppColors.lightOrange, height: 1, thickness: 1);
}

class EditPill extends StatelessWidget {
  const EditPill({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.lightOrange,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        'Edit',
        style: AppTextStyles.mediumText.copyWith(
          color: AppColors.primaryOrange,
          fontSize: 12,
        ),
      ),
    );
  }
}

class SmallPencilEdit extends StatelessWidget {
  const SmallPencilEdit({super.key});
  @override
  Widget build(BuildContext context) =>
      const Icon(Icons.edit_outlined, color: AppColors.lightOrange, size: 16);
}
