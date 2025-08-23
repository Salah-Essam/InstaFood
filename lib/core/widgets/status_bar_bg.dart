import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/colors.dart';

class StatusBarBackground extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final bool showStatusBar;

  const StatusBarBackground({
    super.key,
    required this.child,
    this.backgroundColor = AppColors.statusBar,
    this.showStatusBar = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!showStatusBar) {
      return child;
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: backgroundColor,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Container(
        color: backgroundColor,
        child: Column(
          children: [
            // Status bar area (32px height as requested)
            Container(
              width: 1.sw,
              height: 32.h,
              color: backgroundColor,
            ),
            // Main content
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
