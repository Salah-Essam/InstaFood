import 'package:flutter/material.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/presentation/features/ContactUs%20&%20FAQs/presentation/widgets/contact_us_widget.dart';
import 'package:insta_food/presentation/features/ContactUs%20&%20FAQs/presentation/widgets/faqs_widget.dart';
import 'package:insta_food/presentation/widgets/app_button_onb.dart';
import 'package:insta_food/presentation/widgets/shared_scaffold.dart';

class HelpFAQsPage extends StatefulWidget {
  const HelpFAQsPage({super.key, required this.page});

  final int page;

  @override
  State<HelpFAQsPage> createState() => _HelpFAQsPageState();
}

class _HelpFAQsPageState extends State<HelpFAQsPage> {
  late int switcher;

  @override
  void initState() {
    super.initState();
    switcher = widget.page;
  }

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      appBarTitle: switcher == 1 ? "Help & FAQs" : "Contact Us",
      pageDetails: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: AppButton(
                    borderRadius: 24,
                    height: 30,
                    onPressed: () {
                      setState(() {
                        switcher = 1;
                      });
                    },
                    backgroundColor: (switcher == 1)
                        ? AppColors.primaryOrange
                        : AppColors.lightOrange,
                    child: Text(
                      "FAQ",
                      style: (switcher == 1)
                          ? AppTextStyles.fontWhiteSmallBold
                          : AppTextStyles.fontPrimarySmallBold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: AppButton(
                    height: 30,
                    borderRadius: 24,
                    onPressed: () {
                      setState(() {
                        switcher = 2;
                      });
                    },
                    backgroundColor: (switcher == 2)
                        ? AppColors.primaryOrange
                        : AppColors.lightOrange,
                    child: Text(
                      "Contact Us",
                      style: (switcher == 2)
                          ? AppTextStyles.fontWhiteSmallBold
                          : AppTextStyles.fontPrimarySmallBold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // SizedBox(height: 32),
          (switcher == 1) ? FAQsWidget() : ContactUsWidget(),
        ],
      ),
    );
  }
}
