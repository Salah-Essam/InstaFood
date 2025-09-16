import 'package:flutter/material.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_food/core/routes/router_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:insta_food/presentation/widgets/app_button_onb.dart';

class AppAlerts {
  static Future<void> showSuccessDialog(
    BuildContext context, {
    required String title,
    String? imageAsset,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SizedBox(
            height: 240,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (imageAsset != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Image.asset(
                        imageAsset,
                        width: 72,
                        height: 72,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.check_circle,
                          size: 72,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  Text(
                    title,
                    style: AppTextStyles.dialogTitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    backgroundColor: AppColors.primaryOrange,
                    width: 140,
                    height: 40,
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'OK',
                      style: AppTextStyles.dialogGreetingDialogeWhite,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<void> showLoginRequiredDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxW = constraints.maxWidth;
                  final double rawBtnW = (maxW - 8) / 2; // 1 spacing of 8px
                  final double btnW = rawBtnW.clamp(110.0, 180.0);
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'You can\'t add to cart. Please login or create an account.',
                        style: AppTextStyles.dialogTitle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      OverflowBar(
                        alignment: MainAxisAlignment.spaceBetween,
                        spacing: 8,
                        overflowSpacing: 8,
                        children: [
                          AppButton(
                            backgroundColor: AppColors.lightOrange,
                            width: btnW,
                            height: 40,
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              'Cancel',
                              style: AppTextStyles.dialogGreetingDialogeOrange,
                            ),
                          ),
                          AppButton(
                            backgroundColor: AppColors.primaryOrange,
                            width: btnW,
                            height: 40,
                            onPressed: () {
                              Navigator.of(context).pop();
                              context.go(RouterConstants.login);
                            },
                            child: Text(
                              'Login',
                              style: AppTextStyles.dialogGreetingDialogeWhite,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<dynamic> showLogoutAppDialog(
    BuildContext context, {
    required String title,
    double height = 175,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SizedBox(
            height: height,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      child: Text(
                        textAlign: TextAlign.center,
                        title,
                        maxLines: 2,
                        style: AppTextStyles.dialogTitle,
                      ),
                    ),
                    SizedBox(height: 16),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Wrap(
                        children: [
                          AppButton(
                            backgroundColor: AppColors.lightOrange,
                            width: 100,
                            height: 30,
                            borderRadius: 24,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Cancel",
                              style: AppTextStyles.buttonOrangeText,
                            ),
                          ),
                          SizedBox(height: 8, width: 8),
                          AppButton(
                            backgroundColor: AppColors.primaryOrange,
                            width: 100,
                            height: 30,
                            borderRadius: 24,
                            onPressed: () async {
                              // Close dialog
                              Navigator.of(context).pop();
                              // Perform sign out via AuthCubit
                              context.read<AuthCubit>().signOut();
                              // Navigate to second splash
                              context.go(RouterConstants.secondSplash);
                            },
                            child: Text(
                              "Yes, logout",
                              style: AppTextStyles.buttonWhiteText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
