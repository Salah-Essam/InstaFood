import 'package:flutter/material.dart';
import 'package:insta_food/core/theme/app_colors.dart';

class LightDivider extends StatelessWidget {
  const LightDivider({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 323,
      child: const Divider(
        color: AppColors.orange2,
        height: 1,
        thickness: 1,
      ),
    );
  }
}

class DividerWithSpacing extends StatelessWidget {
  const DividerWithSpacing({super.key});
  @override
  Widget build(BuildContext context) => const Column(
        children: [
          SizedBox(height: 6),
          LightDivider(),
          SizedBox(height: 6),
        ],
      );
}
