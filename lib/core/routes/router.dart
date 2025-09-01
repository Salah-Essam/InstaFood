import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_food/core/routes/router_constants.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/storage/shared_prefrences/shared_prefs_service.dart';
import 'package:insta_food/presentation/features/BottomNavBar/presentation/pages/bottom_nav_bar.dart';
import 'package:insta_food/presentation/features/Profile/presentation/pages/profile_page.dart';

import 'package:insta_food/presentation/features/filter/presentation/view/filter_page.dart';
import 'package:insta_food/presentation/features/home/presentation/view/home_page.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';
import 'package:insta_food/presentation/features/items/presentation/view/item_page.dart';

import 'package:insta_food/presentation/features/auth/presentation/pages/login.dart';
import 'package:insta_food/presentation/features/auth/presentation/pages/set_password.dart';
import 'package:insta_food/presentation/features/auth/presentation/pages/signup.dart';

import 'package:insta_food/presentation/features/onboarding/onboarding.dart';
import 'package:insta_food/presentation/features/search/presentation/search_page.dart';
import 'package:insta_food/presentation/features/splash/view/second_splash_screen.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_state.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouterConstants.splash,
  routes: [
    GoRoute(
      path: RouterConstants.splash,
      builder: (context, state) => _SplashGate(),
    ),
    GoRoute(
      path: RouterConstants.secondSplash,
      builder: (context, state) => const SecondSplashScreen(),
    ),
    GoRoute(
      path: RouterConstants.onboarding,
      builder: (context, state) => BlocProvider(
        create: (_) => OnboardingCubit(),
        child: const OnboardingScreen(),
      ),
    ),
    GoRoute(
      path: RouterConstants.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: RouterConstants.bottomNavBar,
      builder: (context, state) => const BottomNavBar(),
    ),
    GoRoute(
      path: RouterConstants.search,
      builder: (context, state) => const SearchPage(),
    ),
    GoRoute(
      path: RouterConstants.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RouterConstants.signup,
      builder: (context, state) => const SignupPage(),
    ),
    GoRoute(
      path: RouterConstants.forgotPassword,
      builder: (context, state) {
        final email = state.extra as String?;
        return SetPasswordPage(email: email);
      },
    ),
    GoRoute(
      path: RouterConstants.profilePage,
      builder: (context, state) => ProfilePage(),
    ),
    GoRoute(
      path: RouterConstants.filterPage,
      builder: (context, state) => FilterPage(),
    ),
    GoRoute(
      path: RouterConstants.itemPage,
      builder: (context, state) {
        final ItemModel item = state.extra as ItemModel;
        return ItemPage(item: item);
      },
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

    // Check authentication status first
    final authCubit = context.read<AuthCubit>();
    final currentAuthState = authCubit.state;

    if (currentAuthState is Authenticated) {
      // User is already authenticated, go directly to bottom nav bar
      context.go(RouterConstants.bottomNavBar);
      return;
    }

    final prefsService = await SharedPrefsService.getInstance();
    final seen = await prefsService.hasSeenOnboarding();

    if (!mounted) return;

    if (seen) {
      // User has seen onboarding before, show second splash screen
      context.go(RouterConstants.secondSplash);
    } else {
      // First time user, show onboarding
      context.go(RouterConstants.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashYellow,
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
