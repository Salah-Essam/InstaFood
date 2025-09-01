import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';

class SharedScaffold extends StatelessWidget {
  const SharedScaffold({
    super.key,
    required this.appBarTitle,
    required this.pageDetails,
  });

  final String appBarTitle;
  final Widget pageDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryYellow,
      body: Column(
        children: [
          SizedBox(
            height: 125,
            width: double.infinity,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 48, left: 16, right: 64),
                child: Row(
                  children: [
                    InkWell(
                      onTap: context.pop,
                      borderRadius: BorderRadius.circular(24),
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: SvgPicture.asset(
                          AppAssets.backArrow,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(appBarTitle, style: AppTextStyles.greeting),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  left: false,
                  right: false,
                  bottom: true,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    child: pageDetails,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
