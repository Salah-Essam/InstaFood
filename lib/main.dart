import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta_food/core/di/di.dart';
import 'package:flutter/services.dart';
import 'package:insta_food/core/routes/router.dart';

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
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'InstaFood',
          routerConfig: appRouter,
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.white,
          ),
          builder: (context, child) {
            // Set global status bar style
            SystemChrome.setSystemUIOverlayStyle(
              const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.light,
              ),
            );
            return child!;
          },
        );
      },
    );
  }
}
