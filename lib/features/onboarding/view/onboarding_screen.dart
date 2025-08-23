import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:insta_food/core/theme/colors.dart';
import 'package:insta_food/core/theme/styles.dart';
import 'package:insta_food/core/theme/strings.dart';
import 'package:insta_food/routing/routes.dart';
import 'package:go_router/go_router.dart';
import '../logic/cubit/onboarding_cubit.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<OnboardingCubit, OnboardingState>(
          builder: (context, state) {
            final cubit = context.read<OnboardingCubit>();
            return Stack(
              children: [
                Column(
                  children: [
                    // Top bar with Skip/Next
                    SizedBox(
                      height: 48.h,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          children: [
                            const Spacer(),
                            TextButton(
                              onPressed: cubit.skip,
                              child: Text(AppStrings.skip, style: TextStyle(color: AppColors.primary, fontSize: 15.sp, fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: PageView(
                        controller: cubit.pageController,
                        onPageChanged: cubit.onPageChanged,
                        children: const [
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
                    ),
                  ],
                ),

                // Bottom rounded animated sheet
                Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: 1.sw,
                    decoration: BoxDecoration(
                      color: AppColors.sheetBg,
                      boxShadow: [
                        BoxShadow(color: AppColors.sheetShadow, blurRadius: 12, offset: const Offset(0, -4)),
                      ],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        topRight: Radius.circular(16.r),
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h + 12.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icon above title
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: SvgPicture.asset(
                                  state.index == 0
                                      ? 'assets/svgs/Transfer Document icon.svg'
                                      : state.index == 1
                                          ? 'assets/svgs/Card icon.svg'
                                          : 'assets/svgs/Deliver Boy Icon.svg',
                                  width: 32.w,
                                  height: 32.w,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          state.index == 0
                              ? AppStrings.onb1Title
                              : state.index == 1
                                  ? AppStrings.onb2Title
                                  : AppStrings.onb3Title,
                          style: AppTextStyles.title,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          AppStrings.onbBody,
                          style: AppTextStyles.body,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            // Dots + ability to tap to jump
                            Expanded(
                              child: Center(
                                child: SmoothPageIndicator(
                                  controller: cubit.pageController,
                                  count: 3,
                                  effect: ExpandingDotsEffect(
                                    dotHeight: 8.r,
                                    dotWidth: 8.r,
                                    spacing: 8.w,
                                    activeDotColor: AppColors.primary,
                                    dotColor: AppColors.body.withValues(alpha: 0.2),
                                  ),
                                  onDotClicked: (i) => context.read<OnboardingCubit>().goTo(i),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        SizedBox(
                          width: 1.sw,
                          height: 44.h,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
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
                        SizedBox(height: 6.h),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _OnboardPage extends StatelessWidget {
  final String image;
  final String icon;
  final String title;
  final String body;
  const _OnboardPage({required this.image, required this.icon, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Status bar background area
        Container(width: 1.sw, height: 32.h, color: AppColors.statusBar),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: Image.asset(image, width: 1.sw, fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }
}
