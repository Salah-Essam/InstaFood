import 'package:flutter/material.dart';
import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';

class SettingsItemRow extends StatelessWidget {
  const SettingsItemRow({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final Widget icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Row(
        children: [
          SizedBox(width: 35, child: Center(child: icon)),
          SizedBox(width: 16),
          Text(title, style: AppTextStyles.fontBlackMedBold),
          Spacer(),
          Image.asset(AppAssets.reversbackArrow, scale: 3.5),
        ],
      ),
    );
  }
}
