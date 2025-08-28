import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/core/utils/app_strings.dart';

class NotificationsDrawer extends StatelessWidget {
  const NotificationsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(AppAssets.notificationIcon),
                SizedBox(width: 24),
                Text(AppStrings.notifications, style: AppTextStyles.greeting),
              ],
            ),
            Divider(color: AppColors.orange2, height: 64),
            Row(
              children: [
                SvgPicture.asset(AppAssets.productNotification),
                SizedBox(width: 24),
                SizedBox(
                  width: 115,
                  child: Text(
                    "We have added a product you might like.",
                    maxLines: 3,
                    style: AppTextStyles.ad,
                  ),
                ),
              ],
            ),
            Divider(color: AppColors.orange2, height: 32),
            Row(
              children: [
                SvgPicture.asset(AppAssets.favNotification),
                SizedBox(width: 24),
                SizedBox(
                  width: 115,
                  child: Text(
                    "One of your favorite is on promotion.",
                    maxLines: 3,
                    style: AppTextStyles.ad,
                  ),
                ),
              ],
            ),
            Divider(color: AppColors.orange2, height: 32),
            Row(
              children: [
                SvgPicture.asset(AppAssets.orderNotification),
                SizedBox(width: 24),
                SizedBox(
                  width: 115,
                  child: Text(
                    "Your order has been delivered",
                    maxLines: 3,
                    style: AppTextStyles.ad,
                  ),
                ),
              ],
            ),
            Divider(color: AppColors.orange2, height: 32),
            Row(
              children: [
                SvgPicture.asset(AppAssets.deliveryNotification),
                SizedBox(width: 24),
                SizedBox(
                  width: 115,
                  child: Text(
                    "The delivery is on his way",
                    maxLines: 3,
                    style: AppTextStyles.ad,
                  ),
                ),
              ],
            ),
            Divider(color: AppColors.orange2, height: 32),
          ],
        ),
      ),
    );
  }
}
