import 'package:flutter/material.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/presentation/widgets/app_backbutton.dart';

class SharedScaffold extends StatelessWidget {
  const SharedScaffold({
    super.key,
    required this.appBarTitle,
    required this.pageDetails,
    this.fullYellow = false,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 32,
      vertical: 16,
    ),
    this.headerAction,
    this.useSafeAreaAndPadding = true,
    this.leading,
  });

  final String appBarTitle;
  final Widget pageDetails;
  final Widget? leading;
  final bool fullYellow;
  final EdgeInsets contentPadding;
  final Widget? headerAction;
  final bool useSafeAreaAndPadding;

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
                padding: const EdgeInsets.only(top: 48, left: 16, right: 16),
                child: Row(
                  children: [
                    leading ?? AppBackButton(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 32),
                        child: Center(
                          child: Text(
                            appBarTitle,
                            style: AppTextStyles.fontWhiteLargeBold,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    if (headerAction != null) headerAction!,
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: fullYellow
                  ? SafeArea(
                      top: false,
                      left: false,
                      right: false,
                      bottom: true,
                      child: Padding(
                        padding: contentPadding,
                        child: pageDetails,
                      ),
                    )
                  : DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldBackgournd,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                      ),
                      child: useSafeAreaAndPadding
                          ? SafeArea(
                              top: false,
                              left: false,
                              right: false,
                              bottom: true,
                              child: Padding(
                                padding: contentPadding,
                                child: pageDetails,
                              ),
                            )
                          : pageDetails,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
