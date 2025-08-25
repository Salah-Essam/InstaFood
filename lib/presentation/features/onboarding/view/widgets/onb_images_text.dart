import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return Container(
      width: 1.sw,
      height: 1.sh,
      child: Column(
        children: [
          // Image area - fills the remaining space after status bar
          Expanded(
            child: Container(
              width: 1.sw,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24.r),
                  bottomRight: Radius.circular(24.r),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24.r),
                  bottomRight: Radius.circular(24.r),
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
