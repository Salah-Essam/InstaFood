import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_food/core/routes/router_constants.dart';
import 'package:insta_food/core/theme/app_assets.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Prefer router-aware back; fallback to home to avoid black screen
        final router = GoRouter.of(context);
        if (router.canPop()) {
          router.pop();
        } else {
          router.go(RouterConstants.bottomNavBar);
        }
      },
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        width: 35,
        height: 35,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: SvgPicture.asset(AppAssets.backArrow, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
