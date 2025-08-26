import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insta_food/core/theme/app_colors.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.iconWidth,
    this.iconHeight,
    this.fontSize,
  });
  final String label;
  final String icon;
  final VoidCallback onTap;
  final double? iconWidth;
  final double? iconHeight;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            width: iconWidth ?? 32,
            height: iconHeight ?? 32,
          ),
          const SizedBox(width: 16),
          Text(
            label,
            style: TextStyle(
              color: AppColors.orange2,
              fontSize: fontSize ?? 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
