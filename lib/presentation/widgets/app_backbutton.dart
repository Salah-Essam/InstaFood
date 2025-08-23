import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_food/core/app_assets.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: SvgPicture.asset(AppAssets.backArrow),
      onTap: () {
        if (context.canPop()) {
          context.pop();
        }
        ;
      },
    );
  }
}
