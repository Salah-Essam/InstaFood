import 'package:flutter/material.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';

class ShippingAddressSection extends StatelessWidget {
  const ShippingAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Shipping Address', style: AppTextStyles.greeting.copyWith(color: Colors.black)),
        const SizedBox(height: 8),
        SizedBox(
          width: 323,
          height: 35,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.primaryYellow,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: Colors.black87, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '778 Locust View Drive Oaklanda, CA',
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.mediumText.copyWith(color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
