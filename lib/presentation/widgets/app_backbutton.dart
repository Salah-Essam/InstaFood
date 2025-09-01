import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_food/core/theme/app_assets.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
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
