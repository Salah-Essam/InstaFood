import 'package:flutter/material.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';

class OrderSummaryHeader extends StatelessWidget {
  const OrderSummaryHeader({super.key, this.onEdit});

  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Order Summary',
            style: AppTextStyles.mediumText.copyWith(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        InkWell(
          onTap: onEdit,
          borderRadius: BorderRadius.circular(16),
          child: Row(
            children: [
              const Icon(Icons.edit_outlined, size: 16, color: AppColors.lightOrange),
              const SizedBox(width: 4),
              Text(
                'Edit',
                style: AppTextStyles.mediumText.copyWith(
                  color: AppColors.lightOrange,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
