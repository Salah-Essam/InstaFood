import 'package:flutter/material.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';

class SummaryTotalRow extends StatelessWidget {
  const SummaryTotalRow({super.key, required this.total});
  final double total;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '\$${total.toStringAsFixed(2)}',
          style: AppTextStyles.mediumText.copyWith(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
