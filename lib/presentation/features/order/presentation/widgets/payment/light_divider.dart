import 'package:flutter/material.dart';
import 'package:insta_food/core/theme/app_colors.dart';

class LightDivider extends StatelessWidget {
  const LightDivider({super.key});
  @override
  Widget build(BuildContext context) {
    return const Divider(color: AppColors.orange2, height: 1, thickness: 1);
  }
}
