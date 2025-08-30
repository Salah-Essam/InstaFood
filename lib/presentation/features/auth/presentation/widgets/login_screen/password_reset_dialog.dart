import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_food/core/routes/router_constants.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_cubit.dart';

class PasswordResetDialog extends StatelessWidget {
  final String email;

  const PasswordResetDialog({
    super.key,
    required this.email,
  });

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
          // Icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lock_reset,
              size: 32,
              color: AppColors.primary,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Title
          Text(
            'Reset Password?',
            style: AppTextStyles.login.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBrown,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Message
          Text(
            'You\'ve failed to login twice. Would you like to reset your password for:',
            textAlign: TextAlign.center,
            style: AppTextStyles.forgetPassword.copyWith(
              fontSize: 14,
              color: AppColors.darkBrown.withOpacity(0.7),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Email
          Text(
            email,
            textAlign: TextAlign.center,
            style: AppTextStyles.login.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Buttons
          Row(
            children: [
              // Cancel button
              Expanded(
                child: TextButton(
                  onPressed: () {
                    context.read<AuthCubit>().resetFailedAttempts();
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: AppColors.primary),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: AppTextStyles.login.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Reset button
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.go(RouterConstants.forgotPassword, extra: email);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Reset',
                    style: AppTextStyles.login.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
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
