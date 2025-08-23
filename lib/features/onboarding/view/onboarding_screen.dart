import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:insta_food/core/theme/colors.dart';
import 'package:insta_food/core/theme/styles.dart';
import 'package:insta_food/core/theme/strings.dart';
import 'package:insta_food/core/widgets/status_bar_bg.dart';
import 'package:insta_food/routing/routes.dart';
import 'package:go_router/go_router.dart';
import '../logic/cubit/onboarding_cubit.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StatusBarBackground(
      backgroundColor: AppColors.statusBar,
      child: Scaffold(
        backgroundColor: AppColors.statusBar,
        body: SafeArea(
          child: BlocBuilder<OnboardingCubit, OnboardingState>(
            builder: (context, state) {
              final cubit = context.read<OnboardingCubit>();
              return Stack(
                children: [
                  // Main content with PageView
                  PageView(
                    controller: cubit.pageController,
                    onPageChanged: cubit.onPageChanged,
                    children: [
                      _OnboardPage(
                        image: 'assets/images/onboarding1.png',
                        icon: 'assets/svgs/Transfer Document icon.svg',
                        title: AppStrings.onb1Title,
                        body: AppStrings.onbBody,
                      ),
                      _OnboardPage(
                        image: 'assets/images/onboarding2.png',
                        icon: 'assets/svgs/Card icon.svg',
                        title: AppStrings.onb2Title,
                        body: AppStrings.onbBody,
                      ),
                      _OnboardPage(
                        image: 'assets/images/onboarding3.png',
                        icon: 'assets/svgs/Deliver Boy Icon.svg',
                        title: AppStrings.onb3Title,
                        body: AppStrings.onbBody,
                      ),
                    ],
                  ),

                  // Skip button positioned on top right of image
                  Positioned(
                    top: 16.h,
                    right: 16.w,
                    child: TextButton(
                      onPressed: cubit.skip,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                        backgroundColor: Colors.white.withValues(alpha: 0.9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                      child: Text(
                        '${AppStrings.skip} >',
                        style: AppTextStyles.skipButton,
                      ),
                    ),
                  ),

                  // Bottom rounded animated sheet
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: 1.sw,
                      decoration: BoxDecoration(
                        color: AppColors.sheetBg,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.sheetShadow,
                            blurRadius: 12,
                            offset: const Offset(0, -4),
                          ),
                        ],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24.r),
                          topRight: Radius.circular(24.r),
                        ),
                      ),
                      padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 32.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Icon above title
                          SvgPicture.asset(
                            _getIconForIndex(state.index),
                            width: 48.w,
                            height: 48.w,
                            colorFilter: const ColorFilter.mode(
                              AppColors.primary,
                              BlendMode.srcIn,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          
                          // Title
                          Text(
                            _getTitleForIndex(state.index),
                            style: AppTextStyles.title,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 12.h),
                          
                          // Description
                          Text(
                            AppStrings.onbBody,
                            style: AppTextStyles.body,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 24.h),
                          
                          // Page indicator dots
                          SmoothPageIndicator(
                            controller: cubit.pageController,
                            count: 3,
                            effect: ExpandingDotsEffect(
                              dotHeight: 8.h,
                              dotWidth: 8.w,
                              spacing: 8.w,
                              activeDotColor: AppColors.primary,
                              dotColor: AppColors.body.withValues(alpha: 0.2),
                              expansionFactor: 2,
                            ),
                            onDotClicked: (index) => cubit.goTo(index),
                          ),
                          SizedBox(height: 24.h),
                          
                          // Next/Get Started button
                          SizedBox(
                            width: 1.sw,
                            height: 48.h,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () async {
                                final done = await cubit.next();
                                if (done && context.mounted) {
                                  context.go(Routes.home);
                                }
                              },
                              child: Text(
                                state.index == 2 ? AppStrings.getStarted : AppStrings.next,
                                style: AppTextStyles.button,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return 'assets/svgs/Transfer Document icon.svg';
      case 1:
        return 'assets/svgs/Card icon.svg';
      case 2:
        return 'assets/svgs/Deliver Boy Icon.svg';
      default:
        return 'assets/svgs/Transfer Document icon.svg';
    }
  }

  String _getTitleForIndex(int index) {
    switch (index) {
      case 0:
        return AppStrings.onb1Title;
      case 1:
        return AppStrings.onb2Title;
      case 2:
        return AppStrings.onb3Title;
      default:
        return AppStrings.onb1Title;
    }
  }
}

class _OnboardPage extends StatelessWidget {
  final String image;
  final String icon;
  final String title;
  final String body;
  
  const _OnboardPage({
    required this.image,
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 1.sh,
      child: Column(
        children: [
          // Image area - fills the remaining space after status bar
          Expanded(
            child: Container(
              width: 1.sw,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24.r),
                  bottomRight: Radius.circular(24.r),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24.r),
                  bottomRight: Radius.circular(24.r),
                ),
                child: Image.asset(
                  image,
                  width: 1.sw,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
