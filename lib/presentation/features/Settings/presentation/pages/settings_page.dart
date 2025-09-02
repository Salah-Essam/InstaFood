import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_food/core/routes/router_constants.dart';
import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/presentation/features/Settings/presentation/widgets/settings_item_row.dart';
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
