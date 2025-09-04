import 'package:flutter/material.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';

class PaymentMethodRow extends StatelessWidget {
  const PaymentMethodRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/Card_icon.png',
          width: 22,
          height: 22,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Credit Card',
            style: AppTextStyles.mediumText.copyWith(color: Colors.black),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.lightYellow, // #F3E9B5
              borderRadius: BorderRadius.circular(16),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                '•••• •••• •••• 43 /00 /000',
                style: AppTextStyles.mediumText.copyWith(color: Colors.black54),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
