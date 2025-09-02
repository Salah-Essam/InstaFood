import 'package:flutter/material.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/core/constants/menu_constants.dart';

class MenuCategoryBar extends StatelessWidget {
  final List<String> categories;
  final String? active;
  final void Function(String? category) onSelect;
  const MenuCategoryBar({super.key, required this.categories, required this.active, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final allCategories = [MenuConstants.defaultCategory, ...categories];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: 16),
          for (int i = 0; i < allCategories.length; i++) ...[
            _seg(allCategories[i], allCategories[i] == active || (active == null && allCategories[i] == MenuConstants.defaultCategory)),
            if (i < allCategories.length - 1) const SizedBox(width: 8),
          ],
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _seg(String text, bool selected) {
    return InkWell(
      onTap: () => onSelect(selected ? null : text),
      borderRadius: BorderRadius.circular(38),
      child: Container(
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryOrange : AppColors.orange2,
          borderRadius: BorderRadius.circular(38),
          border: Border.all(color: selected ? AppColors.primaryOrange : AppColors.border, width: 1),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          text,
          style: AppTextStyles.mediumText.copyWith(
            fontSize: 12,
            color: selected ? Colors.white : AppColors.primaryOrange,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}