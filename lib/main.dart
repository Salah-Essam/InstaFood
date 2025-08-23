import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta_food/core/di/di.dart';
import 'package:insta_food/core/router/router.dart';
import 'package:insta_food/core/theme/app_theme.dart';
import 'package:insta_food/presentation/features/wrapper/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(const InstaFood());
}

class InstaFood extends StatelessWidget {
  const InstaFood({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // Design size based on your UI mock-up (e.g., Figma)
      designSize: const Size(393, 852),
      builder: (context, child) {
        return MaterialApp.router(theme: AppTheme.theme, routerConfig: router);
      },
    );
  }
}
