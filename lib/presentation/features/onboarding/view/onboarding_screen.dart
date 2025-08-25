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

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  OverlayEntry? _skipButtonOverlay;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSkipButton();
    });
  }

  @override
  void dispose() {
    _skipButtonOverlay?.remove();
    super.dispose();
  }

  void _showSkipButton() {
    _skipButtonOverlay = OverlayEntry(
      builder: (context) => Positioned(
        top: 16.h + MediaQuery.of(context).padding.top,
        right: 16.w,
        child: OnbSkipButton(
          onPressed: () {
            final cubit = context.read<OnboardingCubit>();
            cubit.skip();
          },
        ),
      ),
    );
    Overlay.of(context).insert(_skipButtonOverlay!);
  }

  @override
  Widget build(BuildContext context) {
    return StatusBarBackground(
      backgroundColor: AppColors.statusBar,
      child: Scaffold(
        backgroundColor: AppColors.statusBar,
        body: BlocBuilder<OnboardingCubit, OnboardingState>(
          builder: (context, state) {
            final cubit = context.read<OnboardingCubit>();
            return Stack(
              children: [
                // Full background image
                PageView(
                  controller: cubit.pageController,
                  onPageChanged: cubit.onPageChanged,
                  children: [
                    _buildFullBackgroundImage(
                      OnboardingConstants.firstPageImage,
                    ),
                    _buildFullBackgroundImage(
                      OnboardingConstants.secondPageImage,
                    ),
                    _buildFullBackgroundImage(
                      OnboardingConstants.thirdPageImage,
                    ),
                  ],
                ),

                // Bottom sheet positioned on top of the image
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
    );
  }

  Widget _buildFullBackgroundImage(String imagePath) {
    return Container(
      width: 1.sw,
      height: 1.sh,
      child: Image.asset(
        imagePath,
        width: 1.sw,
        height: 1.sh,
        fit: BoxFit.cover,
      ),
    );
  }
}
