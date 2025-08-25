import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/presentation/features/BottomNavBar/presentation/pages/bottom_nav_bar.dart';
import 'package:insta_food/presentation/features/BottomNavBar/presentation/widgets/cart_drawer.dart';
import 'package:insta_food/presentation/features/BottomNavBar/presentation/widgets/notifications_drawer.dart';
import 'package:insta_food/presentation/features/BottomNavBar/presentation/widgets/profile_drawer.dart';
import 'package:insta_food/presentation/features/Profile/presentation/pages/profile_page.dart';
import 'package:insta_food/presentation/features/home/presentation/home_page.dart';
import 'package:insta_food/presentation/features/onboarding/logic/cubit/onboarding_cubit.dart';
import 'package:insta_food/presentation/features/onboarding/view/onboarding_screen.dart';
import 'package:insta_food/presentation/features/search/presentation/search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Routes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String bottomNavBar = '/bottom_nav_bar';
  static const String profilePage = '/profile_page';
  static const String search = '/search';
  static const String profileDrawer = '/profile_drawer';
  static const String cartDrawer = '/cart_drawer';
  static const String notificationsDrawer = '/notifications_drawer';
}

final GoRouter appRouter = GoRouter(
  initialLocation: Routes.splash,
  routes: [
    GoRoute(
      path: Routes.splash,
      builder: (context, state) => const _SplashGate(),
    ),
    GoRoute(
      path: Routes.onboarding,
      builder: (context, state) => BlocProvider(
        create: (_) => OnboardingCubit(),
        child: const OnboardingScreen(),
      ),
    ),
    GoRoute(path: Routes.home, builder: (context, state) => const HomePage()),
    GoRoute(
      path: Routes.bottomNavBar,
      builder: (context, state) => const BottomNavBar(),
    ),
    GoRoute(
      path: Routes.profilePage,
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      path: Routes.search,
      builder: (context, state) => const SearchPage(),
    ),
  ],
);

class _SplashGate extends StatefulWidget {
  const _SplashGate();
  @override
  State<_SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<_SplashGate>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _startAnimations();
    _decide();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      _fadeController.forward();
      _scaleController.forward();
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  Future<void> _decide() async {
    // Add a minimum delay to show the splash screen
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool(OnboardingCubit.keySeenOnboarding) ?? false;
    if (!mounted) return;
    if (seen) {
      context.go(Routes.bottomNavBar);
    } else {
      context.go(Routes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackground,
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([_fadeController, _scaleController]),
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Image.asset(
                  'assets/images/splashscreen1.png',
                  fit: BoxFit.contain,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
