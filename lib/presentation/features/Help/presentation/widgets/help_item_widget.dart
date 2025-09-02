import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/presentation/widgets/app_backbutton.dart';

class HelpItemWidget extends StatelessWidget {
  const HelpItemWidget({
    super.key,
    required this.title,
    required this.subTitle,
    required this.onTap,
  });

  final String title;
  final String subTitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Divider(color: AppColors.lightOrange, thickness: 2),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.fontBlackLargeBold),
                    Text(subTitle, style: AppTextStyles.fontBlackSmall),
                  ],
                ),
                SizedBox(
                  height: 25,
                  width: 25,
                  child: AppBackButton(isReversed: true, onTap: () {}),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
