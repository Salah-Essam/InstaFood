import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnbImagePager extends StatelessWidget {
  final PageController controller;
  final ValueChanged<int> onPageChanged;
  const OnbImagePager({super.key, required this.controller, required this.onPageChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.sw,
      height: 482.h, // Figma: sheet top at 514px, minus 32px status bar -> 482px visible image
      child: PageView(
        controller: controller,
        onPageChanged: onPageChanged,
        children: const [
          _Image('assets/images/onboarding1.png'),
          _Image('assets/images/onboarding2.png'),
          _Image('assets/images/onboarding3.png'),
        ],
      ),
    );
  }
}

class _Image extends StatelessWidget {
  final String path;
  const _Image(this.path);
  @override
  Widget build(BuildContext context) {
  return Image.asset(path, width: 1.sw, height: 482.h, fit: BoxFit.cover);
  }
}
