import 'package:flutter/material.dart';
import 'package:insta_food/presentation/widgets/shared_scaffold.dart';

class NotificationSettingPage extends StatelessWidget {
  const NotificationSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      appBarTitle: "Notification Setting",
      pageDetails: const SizedBox(),
    );
  }
}
