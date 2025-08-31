import 'package:flutter/material.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_food/core/routes/router_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:insta_food/presentation/widgets/app_button_onb.dart';

class AppAlerts {
  static Future<void> showLoginRequiredDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: SizedBox(
            height: 190,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('You need to login to add items to cart', style: AppTextStyles.dialogTitle, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppButton(
                        backgroundColor: AppColors.lightOrange,
                        width: 120,
                        height: 35,
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Cancel', style: AppTextStyles.dialogGreetingDialogeOrange),
                      ),
                      AppButton(
                        backgroundColor: AppColors.primaryOrange,
                        width: 120,
                        height: 35,
                        onPressed: () {
                          Navigator.of(context).pop();
                          context.go(RouterConstants.login);
                        },
                        child: Text('Login', style: AppTextStyles.dialogGreetingDialogeWhite),
                      ),
                    ],
                  ),
                ],
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppButton(
                            backgroundColor: AppColors.lightOrange,
                            width: 125,
                            height: 35,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Cancel",
                              style: AppTextStyles.dialogGreetingDialogeOrange,
                            ),
                          ),
                          AppButton(
                            backgroundColor: AppColors.primaryOrange,
                            width: 125,
                            height: 35,
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
                              style: AppTextStyles.dialogGreetingDialogeWhite,
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
