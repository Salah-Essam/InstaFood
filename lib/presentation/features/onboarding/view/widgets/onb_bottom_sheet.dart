import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/core/utils/app_strings.dart';
import 'package:insta_food/presentation/widgets/app_button_onb.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../logic/cubit/onboarding_cubit.dart';
import '../../logic/constants/onboarding_constants.dart';

class OnbBottomSheet extends StatelessWidget {
  final VoidCallback? onDone;
  const OnbBottomSheet({super.key, this.onDone});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OnboardingCubit>();
    return Container(
      width: 1.sw,
      height: OnboardingConstants.bottomSheetHeight.h,
      decoration: BoxDecoration(
        color: AppColors.sheetBg.withAlpha(240), // Slightly transparent
        boxShadow: [
          BoxShadow(
            color: AppColors.sheetShadow,
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
      child: BlocBuilder<OnboardingCubit, OnboardingState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              SvgPicture.asset(
                _getIconForIndex(state.index),
                width: OnboardingConstants.iconSize.w,
                height: OnboardingConstants.iconSize.w,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                _getTitleForIndex(state.index),
                style: AppTextStyles.title,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              Text(
                AppStrings.onbBody,
                style: AppTextStyles.body,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              SmoothPageIndicator(
                controller: cubit.pageController,
                count: OnboardingConstants.totalPages,
                effect: WormEffect(
                  dotHeight: OnboardingConstants.pageIndicatorDotHeight,
                  dotWidth: OnboardingConstants.pageIndicatorDotWidth,
                  spacing: OnboardingConstants.pageIndicatorSpacing,
                  activeDotColor: AppColors.primary,
                  dotColor: const Color(0xFFE8E8E8),
                ),
                onDotClicked: (i) => cubit.goTo(i),
              ),
              SizedBox(height: 24.h),
              AppButton(
                label: state.index == OnboardingConstants.lastPageIndex
                    ? AppStrings.getStarted
                    : AppStrings.next,
                onPressed: () async {
                  final done = await cubit.next();
                  if (done && context.mounted) onDone?.call();
                },
                textStyle: AppTextStyles.button,
                width: OnboardingConstants.buttonWidth.w,
                height: OnboardingConstants.buttonHeight.h,
                borderRadius: OnboardingConstants.buttonBorderRadius,
              ),
            ],
          );
        },
      ),
    );
  }

  String _getIconForIndex(int index) {
    switch (index) {
      case OnboardingConstants.firstPageIndex:
        return OnboardingConstants.transferDocumentIcon;
      case OnboardingConstants.secondPageIndex:
        return OnboardingConstants.cardIcon;
      case OnboardingConstants.lastPageIndex:
        return OnboardingConstants.deliverBoyIcon;
      default:
        return OnboardingConstants.transferDocumentIcon;
    }
  }

  String _getTitleForIndex(int index) {
    switch (index) {
      case OnboardingConstants.firstPageIndex:
        return OnboardingConstants.firstPageTitle;
      case OnboardingConstants.secondPageIndex:
        return OnboardingConstants.secondPageTitle;
      case OnboardingConstants.lastPageIndex:
        return OnboardingConstants.thirdPageTitle;
      default:
        return OnboardingConstants.firstPageTitle;
    }
  }
}
