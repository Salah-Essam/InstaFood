import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/utils/app_strings.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/presentation/features/items/data/model/discounted_item.dart';
import 'package:insta_food/presentation/features/items/presentation/view/item_page.dart';
import 'package:insta_food/presentation/widgets/cached_image.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class AdvertismentCard extends StatelessWidget {
  final DiscountedItem item;
  const AdvertismentCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => pushScreen(
        context,
        screen: ItemPage.discounted(item: item),
        withNavBar: true,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          width: 350,
          height: 128,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.primaryOrange,
          ),
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.advertisment,
                            style: AppTextStyles.ad,
                            textAlign: TextAlign.center,
                          ),
                          Text(AppStrings.ad2, style: AppTextStyles.ad),
                          Text(
                            "${item.discountPercentage}${AppStrings.off}",
                            style: AppTextStyles.greeting,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      child: CachedImage(
                        item: item,
                        width: 161.5,
                        height: double.infinity,
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 0,
                left: 110,
                child: SvgPicture.asset(AppAssets.ellipse),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: SvgPicture.asset(
                  AppAssets.ellipseRotated,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
