import 'package:flutter/material.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/presentation/widgets/app_button_onb.dart';

class FAQsWidget extends StatefulWidget {
  const FAQsWidget({super.key});

  @override
  State<FAQsWidget> createState() => _FAQsWidgetState();
}

class _FAQsWidgetState extends State<FAQsWidget> {
  int switcher = 1;
  @override
  Widget build(BuildContext context) {
    return Column(
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
                    "General",
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
                    "Account",
                    style: (switcher == 2)
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
                      switcher = 3;
                    });
                  },
                  backgroundColor: (switcher == 3)
                      ? AppColors.primaryOrange
                      : AppColors.lightOrange,
                  child: Text(
                    "Services",
                    style: (switcher == 3)
                        ? AppTextStyles.fontWhiteSmallBold
                        : AppTextStyles.fontPrimarySmallBold,
                  ),
                ),
              ),
            ),
          ],
        ),
        // AppSearchBar(isEnabled: true, height: 50),
      ],
    );
  }
}
