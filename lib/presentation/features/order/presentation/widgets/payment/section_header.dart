import 'package:flutter/material.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.showEdit = false, this.onEdit});
  final String title;
  final bool showEdit;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.mediumText.copyWith(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
          ),
        ),
        if (showEdit)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.orange2,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text('Edit', style: AppTextStyles.mediumText.copyWith(color: AppColors.primaryOrange, fontSize: 12)),
          ),
      ],
    );
  }
}
