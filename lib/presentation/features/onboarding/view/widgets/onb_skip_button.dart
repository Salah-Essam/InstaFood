import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta_food/core/theme/app_strings.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';

class OnbSkipButton extends StatelessWidget {
  final VoidCallback onPressed;

  const OnbSkipButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        backgroundColor: Colors.transparent,
        minimumSize: Size(0, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(AppStrings.skip, style: AppTextStyles.skipButton),
          SizedBox(width: 2.w),
          Icon(
            Icons.chevron_right,
            size: 18.sp,
            color: AppTextStyles.skipButton.color,
          ),
        ],
      ),
    );
  }
}
