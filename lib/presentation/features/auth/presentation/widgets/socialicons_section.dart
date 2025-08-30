import 'package:flutter/material.dart';
import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/presentation/widgets/app_socialicon_button.dart';

class SocialIconsSection extends StatelessWidget {
  const SocialIconsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),

        Center(
          child: Text(
            'or sign up with',
            style: AppTextStyles.small.copyWith(
              color: AppColors.textDarkBrown,
              fontSize: 14,
            ),
          ),
        ),

        const SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialIconButton(
              assetPath: AppAssets.google,
              onPressed: () {
                // TODO: Implement Google authentication when service is ready
                debugPrint(
                  'Google login pressed - authentication not implemented yet',
                );
              },
              size: 56,
              iconSize: 28,
              borderRadius: 28,
            ),
            const SizedBox(width: 16),
            SocialIconButton(
              assetPath: AppAssets.facebook,
              onPressed: () {
                // TODO: Implement Facebook authentication when service is ready
                debugPrint(
                  'Facebook login pressed - authentication not implemented yet',
                );
              },
              size: 56,
              iconSize: 28,
              borderRadius: 28,
            ),
            const SizedBox(width: 16),
            SocialIconButton(
              assetPath: AppAssets.fingerprint,
              onPressed: () {
                // TODO: Implement biometric authentication when service is ready
                debugPrint(
                  'Biometric authentication pressed - service not implemented yet',
                );
              },
              size: 56,
              iconSize: 28,
              borderRadius: 28,
            ),
          ],
        ),
      ],
    );
  }
}
