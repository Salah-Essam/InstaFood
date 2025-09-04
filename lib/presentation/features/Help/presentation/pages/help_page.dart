import 'package:flutter/material.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/presentation/features/ContactUs_and_FAQs/presentation/pages/help_faqs_page.dart';
import 'package:insta_food/presentation/features/Help/presentation/pages/support_page.dart';
import 'package:insta_food/presentation/features/Help/presentation/widgets/help_item_widget.dart';
import 'package:insta_food/presentation/widgets/shared_scaffold.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      appBarTitle: "Help",
      pageDetails: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Column(
          children: [
            Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent pellentesque congue lorem, vel tincidunt tortor.",
              style: AppTextStyles.fontBlackSmall,
            ),
            SizedBox(height: 24),
            HelpItemWidget(
              title: "Help with the order",
              subTitle: "Support",
              onTap: () {
                pushScreen(context, screen: SupportPage());
              },
            ),
            HelpItemWidget(
              title: "Help center",
              subTitle: "General Information",
              onTap: () {
                pushScreen(context, screen: HelpFAQsPage(page: 1));
              },
            ),
            Divider(color: AppColors.lightOrange, thickness: 2),
          ],
        ),
      ),
    );
  }
}
