import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_food/core/routes/router_constants.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:insta_food/presentation/widgets/app_button_onb.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  const LogoutConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      contentPadding: const EdgeInsets.all(24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Text(
            'Log Out',
            style: AppTextStyles.login.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBrown,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Message
          Text(
            'Are you sure you want to log out?',
            textAlign: TextAlign.center,
            style: AppTextStyles.forgetPassword.copyWith(
              fontSize: 14,
              color: AppColors.darkBrown.withOpacity(0.7),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Buttons
          Row(
            children: [
              // Cancel button
              Expanded(
                child: AppButton(
                  label: 'Cancel',
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  backgroundColor: Colors.transparent,
                  border: BorderSide(color: AppColors.primary),
                  borderRadius: 8,
                  textStyle: AppTextStyles.login.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Logout button
              Expanded(
                child: AppButton(
                  label: 'Log Out',
                  onPressed: () {
                    context.read<AuthCubit>().signOut();
                    context.go(RouterConstants.secondSplash);
                  },
                  backgroundColor: Colors.red,
                  borderRadius: 8,
                  textStyle: AppTextStyles.login.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
