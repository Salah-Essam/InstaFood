import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/core/utils/app_strings.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';
import 'package:insta_food/presentation/features/items/presentation/widgets/app_counter.dart';
import 'package:insta_food/presentation/features/items/presentation/widgets/fav_button.dart';
import 'package:insta_food/presentation/features/items/presentation/widgets/radio_button_collection.dart';
import 'package:insta_food/presentation/features/items/presentation/widgets/rating_container.dart';
import 'package:insta_food/presentation/widgets/app_backbutton.dart';
import 'package:insta_food/presentation/widgets/app_button_onb.dart';
import 'package:insta_food/presentation/widgets/cached_image.dart';

class ItemPage extends StatelessWidget {
  final ItemModel item;
  const ItemPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryYellow,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60, right: 35, left: 35),
            child: Row(
              spacing: 3,
              children: [
                Align(alignment: Alignment.centerLeft, child: AppBackButton()),
                Text(item.itemName, style: AppTextStyles.header),
                Spacer(),
                FavButton(),
              ],
            ),
          ),
          Align(alignment: Alignment.centerLeft, child: RatingContainer()),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: SizedBox(
                width: double.infinity,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 35,
                      vertical: 33,
                    ),
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(36),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(36),
                          child: CachedImage(
                            item: item,
                            width: 323,
                            height: 223,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.symmetric(
                            horizontal: BorderSide(
                              color: AppColors.border,
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "\$${item.itemPrice}",
                                style: AppTextStyles.itemPagePrice,
                              ),
                              Counter(),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(item.itemName, style: AppTextStyles.header),
                      Text(
                        item.itemDescription!,
                        style: AppTextStyles.mediumText,
                      ),
                      SizedBox(height: 29),
                      Text(AppStrings.portions, style: AppTextStyles.header),
                      RadioButtonCollection(),
                      AppButton(
                        width: 180,
                        onPressed: () {},
                        borderRadius: 44.79,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              AppAssets.orderBag,
                              fit: BoxFit.fitHeight,
                            ),
                            SizedBox(width: 14),
                            Text(
                              AppStrings.addToCart,
                              style: AppTextStyles.button,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
