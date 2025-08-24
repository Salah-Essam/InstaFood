import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/core/utils/app_strings.dart';
import 'package:insta_food/presentation/widgets/app_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../logic/cubit/onboarding_cubit.dart';

class OnbBottomSheet extends StatelessWidget {
  final VoidCallback? onDone;
  const OnbBottomSheet({super.key, this.onDone});

  String _icon(int i) => i == 0
      ? 'assets/svgs/Transfer Document icon.svg'
      : i == 1
      ? 'assets/svgs/Card icon.svg'
      : 'assets/svgs/Deliver Boy Icon.svg';

  String _title(int i) => i == 0
      ? AppStrings.onb1Title
      : i == 1
      ? AppStrings.onb2Title
      : AppStrings.onb3Title;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OnboardingCubit>();
    return Container(
      width: 1.sw,
      height: 338.h,
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
                _icon(state.index),
                width: 48.w,
                height: 48.w,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                _title(state.index),
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
                count: 3,
                effect: const WormEffect(
                  dotHeight: 6,
                  dotWidth: 16,
                  spacing: 8,
                  activeDotColor: AppColors.primary,
                  dotColor: Color(0xFFE8E8E8),
                ),
                onDotClicked: (i) => cubit.goTo(i),
              ),
              SizedBox(height: 24.h),
              AppButton(
                label: state.index == 2
                    ? AppStrings.getStarted
                    : AppStrings.next,
                onPressed: () async {
                  final done = await cubit.next();
                  if (done && context.mounted) onDone?.call();
                },
                textStyle: AppTextStyles.button,
                width: 133.w,
                height: 36.h,
                borderRadius: 24,
              ),
            ],
          );
        },
      ),
    );
  }
}
