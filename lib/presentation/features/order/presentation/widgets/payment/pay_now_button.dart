import 'package:flutter/material.dart';
import 'package:insta_food/core/theme/app_colors.dart';

class PayNowButton extends StatelessWidget {
  const PayNowButton({super.key, required this.onPressed});
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 220,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.lightOrange,
            foregroundColor: AppColors.primaryOrange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: onPressed,
          child: const Text('Pay Now'),
        ),
      ),
    );
  }
}
