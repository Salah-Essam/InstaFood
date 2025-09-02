import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_food/core/di/di.dart';
import 'package:flutter/services.dart';
import 'package:insta_food/core/routes/router.dart';
import 'package:insta_food/core/routes/router_constants.dart';
import 'package:insta_food/core/theme/app_theme.dart';
import 'package:insta_food/presentation/features/Restaurants/data/repository/restaurants_repository.dart';
import 'package:insta_food/presentation/features/Restaurants/presentation/cubit/restaurants_cubit.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_state.dart';
import 'package:insta_food/presentation/features/drawer/presentation/cubit/drawer_cubit.dart';
import 'package:insta_food/presentation/features/cart/logic/cart_cubit.dart';
import 'package:insta_food/presentation/features/order/logic/orders_cubit.dart';

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
        BlocProvider(
          create: (context) => RestaurantsCubit(
            repository: context.read<RestaurantsRepository>(),
            connectivity: Connectivity(),
          )..initialize(),
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

            return BlocListener<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is Authenticated) {
                  // Start/refresh orders streaming now that we have a uid
                  if (context.mounted) {
                    try {
                      context.read<OrdersCubit>().init();
                    } catch (_) {}
                  }
                  // User authenticated, go to home if not already there
                  final currentLocation = GoRouter.of(
                    context,
                  ).routerDelegate.currentConfiguration.fullPath;
                  if (currentLocation != RouterConstants.home) {
                    context.go(RouterConstants.home);
                  }
                } else if (state is SignedUp) {
                  final currentLocation = GoRouter.of(
                    context,
                  ).routerDelegate.currentConfiguration.fullPath;
                  if (currentLocation != RouterConstants.login) {
                    context.go(RouterConstants.login);
                  }
                } else if (state is Unauthenticated) {
                  // User not authenticated, go to second splash (login/signup screen)
                  final currentLocation = GoRouter.of(
                    context,
                  ).routerDelegate.currentConfiguration.fullPath;
                  if (currentLocation != RouterConstants.secondSplash &&
                      currentLocation != RouterConstants.login &&
                      currentLocation != RouterConstants.signup &&
                      currentLocation != RouterConstants.splash &&
                      currentLocation != RouterConstants.onboarding) {
                    context.go(RouterConstants.secondSplash);
                  }
                }
              },
              child: child!,
            );
          },
        );
      },
    );
  }
}
