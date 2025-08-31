import 'package:flutter/material.dart';
import 'package:insta_food/core/theme/app_colors.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "By continuing, you agree to ",
            style: TextStyle(color: AppColors.blackish, fontSize: 14),
            children: [
              WidgetSpan(
                child: GestureDetector(
                  onTap: () {},
                  child: Text(
                    "Terms of Use",
                    style: TextStyle(
                      color: AppColors.primaryOrange,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              TextSpan(
                text: " and ",
                style: TextStyle(color: AppColors.blackish, fontSize: 14),
              ),
              WidgetSpan(
                child: GestureDetector(
                  onTap: () {},
                  child: Text(
                    "Privacy Policy",
                    style: TextStyle(
                      color: AppColors.primaryOrange,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              TextSpan(
                text: ".",
                style: TextStyle(color: AppColors.blackish, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
