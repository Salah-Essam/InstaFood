import 'package:flutter/material.dart';
import '../theme/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatusBarBg extends StatelessWidget {
  final double? height;
  const StatusBarBg({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: (height ?? 32.h).clamp(0, 60),
      color: AppColors.statusBar,
    );
  }
}
