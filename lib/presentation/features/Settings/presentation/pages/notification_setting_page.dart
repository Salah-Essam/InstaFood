import 'package:flutter/material.dart';
import 'package:insta_food/presentation/features/Settings/presentation/widgets/notification_settings_item.dart';
import 'package:insta_food/presentation/widgets/shared_scaffold.dart';

class NotificationSettingPage extends StatelessWidget {
  const NotificationSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      appBarTitle: "Notification Setting",
      pageDetails: Padding(
        padding: EdgeInsetsGeometry.only(top: 24),
        child: Column(
          children: [
            NotificationSettingsItem(
              title: "General Notification",
              value: true,
              onToggle: (value) {},
            ),
            SizedBox(height: 16),
            NotificationSettingsItem(
              title: "Sound",
              value: true,
              onToggle: (value) {},
            ),
            SizedBox(height: 16),

            NotificationSettingsItem(
              title: "Sound Call",
              value: true,
              onToggle: (value) {},
            ),
            SizedBox(height: 16),

            NotificationSettingsItem(
              title: "Vibrate",
              value: false,
              onToggle: (value) {},
            ),
            SizedBox(height: 16),

            NotificationSettingsItem(
              title: "Special Offers",
              value: false,
              onToggle: (value) {},
            ),
            SizedBox(height: 16),

            NotificationSettingsItem(
              title: "Payments",
              value: false,
              onToggle: (value) {},
            ),
            SizedBox(height: 16),

            NotificationSettingsItem(
              title: "Promo and discount",
              value: false,
              onToggle: (value) {},
            ),
            SizedBox(height: 16),

            NotificationSettingsItem(
              title: "Cashback",
              value: false,
              onToggle: (value) {},
            ),
          ],
        ),
      ),
    );
  }
}
