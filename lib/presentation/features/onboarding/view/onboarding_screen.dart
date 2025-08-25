import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta_food/core/routes/router.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/presentation/widgets/status_bar_bg.dart';
import 'package:go_router/go_router.dart';
import '../logic/cubit/onboarding_cubit.dart';
import '../logic/constants/onboarding_constants.dart';
import 'widgets/onb_images_text.dart';
import 'widgets/onb_skip_button.dart';
import 'widgets/onb_bottom_sheet.dart';

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
                      OnbImagesText(
                        image: OnboardingConstants.firstPageImage,
                        icon: OnboardingConstants.transferDocumentIcon,
                        title: OnboardingConstants.firstPageTitle,
                        body: OnboardingConstants.pageBody,
                      ),
                      OnbImagesText(
                        image: OnboardingConstants.secondPageImage,
                        icon: OnboardingConstants.cardIcon,
                        title: OnboardingConstants.secondPageTitle,
                        body: OnboardingConstants.pageBody,
                      ),
                      OnbImagesText(
                        image: OnboardingConstants.thirdPageImage,
                        icon: OnboardingConstants.deliverBoyIcon,
                        title: OnboardingConstants.thirdPageTitle,
                        body: OnboardingConstants.pageBody,
                      ),
                    ],
                  ),

                  // Skip button
                  OnbSkipButton(onPressed: cubit.skip),

                  // Bottom sheet
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: OnbBottomSheet(
                      onDone: () {
                        if (context.mounted) {
                          context.go(Routes.bottomNavBar);
                        }
                      },
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
}
