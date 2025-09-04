import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta_food/core/di/di.dart';
import 'package:flutter/services.dart';
import 'package:insta_food/core/routes/router.dart';
import 'package:insta_food/core/theme/app_theme.dart';
import 'package:insta_food/presentation/features/Restaurants/presentation/cubit/restaurants_cubit.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:insta_food/presentation/features/drawer/presentation/cubit/drawer_cubit.dart';
import 'package:insta_food/presentation/features/cart/logic/cart_cubit.dart';
import 'package:insta_food/presentation/features/order/logic/orders_cubit.dart';
import 'package:insta_food/presentation/features/favorites/logic/favorites_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<DrawerCubit>()),
        BlocProvider<AuthCubit>(
          create: (_) => sl<AuthCubit>()..checkAuthStatus(),
        ),

        BlocProvider(create: (_) => sl<FavoritesCubit>()..init()),

        BlocProvider(
          create: (ctx) => CartCubit(
            repo: sl(),
            authCubit: ctx.read<AuthCubit>(),
            session: sl(),
          ),
        ),
        BlocProvider(
          create: (ctx) =>
              OrdersCubit(repo: sl(), auth: ctx.read<AuthCubit>())..init(),
        ),
        // Single RestaurantsCubit provider (removed duplicate)
        BlocProvider(
          create: (context) => sl<RestaurantsCubit>(),
        ),
      ],
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

            // Removed global auth navigation listener; each page / router redirect now handles auth routing.
            return child!;
          },
        );
      },
    );
  }
}
