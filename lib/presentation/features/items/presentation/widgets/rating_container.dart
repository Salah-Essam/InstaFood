import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';

class RatingContainer extends StatelessWidget {
  //customization
  final Color? color;
  final String? rating;
  final TextStyle? style;
  const RatingContainer({super.key, this.color, this.rating, this.style});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 57, vertical: 6),
      child: Container(
        width: 34,
        height: 14,
        decoration: BoxDecoration(
          color: color ?? AppColors.primaryOrange,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 2,
          children: [
            Text(rating ?? "5.0", style: style ?? AppTextStyles.price),
            SvgPicture.asset(AppAssets.star),
          ],
        ),
      ),
    );
  }
}
