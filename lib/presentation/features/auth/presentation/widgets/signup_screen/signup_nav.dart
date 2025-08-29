import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_food/core/routes/router_constants.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';

class SignupNav {
  static Widget buildSignupNav(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          context.push(RouterConstants.signup);
        },
        child: RichText(
          text: TextSpan(
            text: "Don't have an account? ",
            style: AppTextStyles.small.copyWith(
              color: const Color(0xFF8B4513),
              fontSize: 14,
            ),
            children: [
              TextSpan(
                text: 'Sign Up',
                style: AppTextStyles.small.copyWith(
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}