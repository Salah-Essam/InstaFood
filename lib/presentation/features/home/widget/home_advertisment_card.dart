import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/core/utils/image_error.dart';
import 'package:insta_food/core/utils/app_strings.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';

class AdvertismentCard extends StatelessWidget {
  final ItemModel item;
  const AdvertismentCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 323,
      height: 128,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.primary,
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppStrings.advertisment, style: AppTextStyles.ad),
                      Text(AppStrings.ad2, style: AppTextStyles.ad),
                      Text(AppStrings.ad3, style: AppTextStyles.greeting),
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
                  child: Image.network(
                    item.imageUrl,
                    width: 161.5,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: ImageError.imageErrorLoader(),
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
            child: SvgPicture.asset(AppAssets.ellipse2, fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }
}
