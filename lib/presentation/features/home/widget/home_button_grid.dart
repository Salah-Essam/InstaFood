import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/core/utils/app_strings.dart';
import 'package:insta_food/presentation/widgets/app_button_onb.dart';

class ButtonGrid extends StatelessWidget {
  ButtonGrid({super.key});
  final Map<String, String> categories = {
    AppStrings.snacks: AppAssets.snacks,
    AppStrings.meals: AppAssets.meals,
    AppStrings.vegan: AppAssets.vegan,
    AppStrings.desserts: AppAssets.desserts,
    AppStrings.drinks: AppAssets.drinks,
  };
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        itemCount: categories.length,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),

        itemBuilder: (context, index) {
          // Get the category key and asset path by index
          final categoryName = categories.keys.elementAt(index);
          final asset = categories[categoryName]!;
          return Padding(
            padding: const EdgeInsets.only(right: 19, left: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppButton(
                  onPressed: () {},
                  backgroundColor: AppColors.lightYellow,
                  borderRadius: 30,
                  width: 49,
                  height: 62,
                  child: SizedBox(
                    height: 37,
                    width: 33,
                    child: Transform.scale(
                      scale: 1,
                      child: SvgPicture.asset(asset, fit: BoxFit.contain),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(categoryName, style: AppTextStyles.small),
              ],
            ),
          );
        },
      ),
    );
  }
}
