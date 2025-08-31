import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_food/core/theme/app_assets.dart';

class FavButton extends StatelessWidget {
  final double? height;
  final double? width;
  const FavButton({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: SvgPicture.asset(
        AppAssets.favOrange,
        fit: BoxFit.cover,
        width: width ?? 21,
        height: height ?? 21,
      ),
    );
  }
}
