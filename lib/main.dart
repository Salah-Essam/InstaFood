import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta_food/core/di/di.dart';
import 'package:flutter/services.dart';
import 'package:insta_food/core/routes/router.dart';
import 'package:insta_food/core/theme/app_theme.dart';
import 'package:insta_food/presentation/features/drawer/presentation/cubit/drawer_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (_) => sl<DrawerCubit>())],
      child: const InstaFood(),
    ),
  );
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
          theme: AppTheme.theme,
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
