import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../logic/constants/onboarding_constants.dart';

class OnbImagesText extends StatelessWidget {
  final String image;
  final String icon;
  final String title;
  final String body;

  const OnbImagesText({
    super.key,
    required this.image,
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.sw,
      height: 1.sh - OnboardingConstants.bottomSheetHeight.h,
      child: Column(
        children: [
          // Image area - fills the space above the bottom sheet
          Expanded(
            child: Container(
              width: 1.sw,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.r),
                  bottomRight: Radius.circular(20.r),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.r),
                  bottomRight: Radius.circular(20.r),
                ),
                child: Image.asset(
                  image,
                  width: 1.sw,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
