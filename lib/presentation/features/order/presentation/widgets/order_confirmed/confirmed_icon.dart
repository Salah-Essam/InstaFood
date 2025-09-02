import 'package:flutter/material.dart';
import 'package:insta_food/core/theme/app_colors.dart';

class ConfirmedIcon extends StatelessWidget {
  const ConfirmedIcon({super.key, this.size = 160});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.orange2.withAlpha(38),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primaryOrange, width: 6),
      ),
      child: Center(
        child: Container(
          width: size * 0.1,
          height: size * 0.1,
          decoration: const BoxDecoration(
            color: AppColors.primaryOrange,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
