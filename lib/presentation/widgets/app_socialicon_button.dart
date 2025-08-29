import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialIconButton extends StatelessWidget {
  final String assetPath;
  final VoidCallback onPressed;
  final double? size;
  final double? iconSize;
  final double? borderRadius;

  const SocialIconButton({
    super.key,
    required this.assetPath,
    required this.onPressed,
    this.size,
    this.iconSize,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        child: Center(
          child: SvgPicture.asset(
            assetPath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

