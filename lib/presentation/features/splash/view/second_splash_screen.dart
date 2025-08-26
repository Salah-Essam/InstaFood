import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_food/core/routes/router.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/storage/shared_prefrences/shared_prefs_service.dart';
import 'package:insta_food/presentation/widgets/app_button_onb.dart';

class SecondSplashScreen extends StatefulWidget {
  const SecondSplashScreen({super.key});

  @override
  State<SecondSplashScreen> createState() => _SecondSplashScreenState();
}

class _SecondSplashScreenState extends State<SecondSplashScreen>
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondSplashBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Top section with image and text
            Expanded(
              flex: 3,
              child: Center(
                child: AnimatedBuilder(
                  animation: Listenable.merge([
                    _fadeController,
                    _scaleController,
                  ]),
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Image with specified dimensions
                            SizedBox(
                              width: 202.31.w,
                              height: 257.6.h,
                              child: Image.asset(
                                'assets/images/splashscreen2.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(height: 20.h),
                            // Description text
                            Container(
                              width: 295.w,
                              child: Text(
                                'Discover tasty meals nearby and get them fast',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Bottom section with buttons
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Login button
                    AppButton(
                      label: 'Log In',
                      onPressed: () async {
                        // Mark second splash as completed
                        final prefsService =
                            await SharedPrefsService.getInstance();
                        await prefsService.markSecondSplashCompleted();
                        // Navigate to login screen
                        if (mounted) {
                          context.go(Routes.login);
                        }
                      },
                      backgroundColor: AppColors.loginButtonBackground,
                      width: 207.w,
                      height: 45.h,
                      borderRadius: 30,
                      textStyle: TextStyle(
                        color: AppColors.buttonTextColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Sign Up button
                    AppButton(
                      label: 'Sign Up',
                      onPressed: () async {
                        // Mark second splash as completed
                        final prefsService =
                            await SharedPrefsService.getInstance();
                        await prefsService.markSecondSplashCompleted();
                        // Navigate to signup screen
                        if (mounted) {
                          context.go(Routes.signup);
                        }
                      },
                      backgroundColor: AppColors.signupButtonBackground,
                      width: 207.w,
                      height: 45.h,
                      borderRadius: 30,
                      textStyle: TextStyle(
                        color: AppColors.buttonTextColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Explore as guest button
                    GestureDetector(
                      onTap: () async {
                        // Mark second splash as completed
                        final prefsService =
                            await SharedPrefsService.getInstance();
                        await prefsService.markSecondSplashCompleted();
                        // Navigate to home screen
                        if (mounted) {
                          context.go(Routes.bottomNavBar);
                        }
                      },
                      child: Text(
                        'Explore as guest',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
