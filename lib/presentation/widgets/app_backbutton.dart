import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_food/core/theme/app_assets.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 7.0),
      child: InkWell(
        child: SvgPicture.asset(
          AppAssets.backArrow,
          fit: BoxFit.fitWidth,
          width: 25,
          height: 25,
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
