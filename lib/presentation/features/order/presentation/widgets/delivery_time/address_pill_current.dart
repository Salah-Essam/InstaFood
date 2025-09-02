import 'package:flutter/material.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';

class AddressPillCurrent extends StatelessWidget {
  const AddressPillCurrent({super.key, this.text = 'Your current location'});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E9B5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined, color: Colors.black87, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.mediumText.copyWith(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
