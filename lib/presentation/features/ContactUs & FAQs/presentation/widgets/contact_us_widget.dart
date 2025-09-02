import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/presentation/features/Settings/presentation/widgets/settings_item_row.dart';

class ContactUsWidget extends StatelessWidget {
  const ContactUsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 32),
        SettingsItemRow(
          icon: SvgPicture.asset(AppAssets.customerService),
          title: "Customer Service",
          onTap: () {},
        ),
        SizedBox(height: 16),
        SettingsItemRow(
          icon: SvgPicture.asset(AppAssets.website),
          title: "Website",
          onTap: () {},
        ),
        SizedBox(height: 16),
        SettingsItemRow(
          icon: Image.asset(AppAssets.whatApp),
          title: "Whatsapp",
          onTap: () {},
        ),
        SizedBox(height: 16),
        SettingsItemRow(
          icon: SvgPicture.asset(AppAssets.facebookoutline),
          title: "Facebook",
          onTap: () {},
        ),
        SizedBox(height: 16),
        SettingsItemRow(
          icon: Image.asset(AppAssets.instagram),
          title: "Instagram",
          onTap: () {},
        ),
      ],
    );
  }
}
