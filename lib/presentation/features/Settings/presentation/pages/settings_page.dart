import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_food/core/routes/router_constants.dart';
import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/presentation/widgets/shared_scaffold.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      appBarTitle: "Settings",
      pageDetails: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsItemRow(
              icon: SvgPicture.asset(AppAssets.settingsNotificationIcon),
              title: "Notification Setting",
              onTap: () {
                context.push(RouterConstants.notificationSetting);
              },
            ),
            SizedBox(height: 16),
            SettingsItemRow(
              icon: SvgPicture.asset(AppAssets.settingsKeyIcon),
              title: "Password Setting",
              onTap: () {
                context.push(RouterConstants.passwordSetting);
              },
            ),
            SizedBox(height: 16),
            SettingsItemRow(
              icon: SvgPicture.asset(AppAssets.settingsUserIcon),
              title: "Delete Account",
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsItemRow extends StatelessWidget {
  const SettingsItemRow({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final Widget icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Row(
        children: [
          SizedBox(width: 35, child: Center(child: icon)),
          SizedBox(width: 16),
          Text(title, style: AppTextStyles.fontBlackMedBold),
          Spacer(),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppColors.primaryOrange,
            size: 20,
          ),
        ],
      ),
    );
  }
}
