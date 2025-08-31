import 'package:flutter/material.dart';
import 'package:insta_food/core/theme/app_colors.dart';

class WelcomeSection extends StatelessWidget {
  const WelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome',
          style: TextStyle(
            color: AppColors.textDarkBrown,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
          style: TextStyle(
            color: AppColors.blackish,
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
