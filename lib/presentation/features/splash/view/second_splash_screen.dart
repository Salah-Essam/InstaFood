import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_food/core/routes/router_constants.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/storage/shared_prefrences/shared_prefs_service.dart';
import 'package:insta_food/presentation/widgets/app_button_onb.dart';

class SecondSplashScreen extends StatelessWidget {
  const SecondSplashScreen({super.key});

  Future<void> _markSeen() async {
    final prefs = await SharedPrefsService.getInstance();
    await prefs.markSecondSplashCompleted();
  }

  @override
  Widget build(BuildContext context) {
    // Compute a safe top for content so it starts below the image bottom
    final media = MediaQuery.of(context);
    final screenHeight = media.size.height;
    final paddingTop = media.padding.top;
    final imgHeight = 257.6021728515625.h;
    // Image is vertically centered inside SafeArea; top = paddingTop + (available - imgHeight)/2
    final available = screenHeight - media.padding.vertical;
    final imageTop = paddingTop + (available - imgHeight) / 2;
    final imageBottom = imageTop + imgHeight;
    final contentTop = imageBottom + 6.h; // very small gap under image

    return Scaffold(
      backgroundColor: AppColors.secondSplashBackground,
      body: SafeArea(
        child: Stack(
          children: [
            // Centered image to match Splash 1
            Center(
              child: Image.asset(
                'assets/images/splashscreen2.png',
                width: 202.30677795410156.w,
                height: 257.6021728515625.h,
                fit: BoxFit.contain,
              ),
            ),

            // Content positioned to start below image bottom to avoid overlap (no scroll)
            Positioned(
              top: contentTop,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.only(bottom: 32.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 295.w,
                      // Scale text down to ensure it fits on one line fully
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.center,
                        child: Text(
                          'Discover tasty meals nearby and get them fast.',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          softWrap: false,
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 9.h), // very small gap
                    AppButton(
                      label: 'Log In',
                      onPressed: () async {
                        await _markSeen();
                        if (context.mounted) {
                          context.push(RouterConstants.login);
                        }
                      },
                      backgroundColor: AppColors.loginButtonBackground,
                      width: 207.w,
                      height: 45.h,
                      borderRadius: 30,
                      textStyle: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        height: 22.h / 16.sp,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    AppButton(
                      label: 'Sign Up',
                      onPressed: () async {
                        await _markSeen();
                        if (context.mounted) {
                          context.push(RouterConstants.signup);
                        }
                      },
                      backgroundColor: AppColors.signupButtonBackground,
                      width: 207.w,
                      height: 45.h,
                      borderRadius: 30,
                      textStyle: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        height: 22.h / 16.sp,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    TextButton(
                      onPressed: () async {
                        await _markSeen();
                        if (context.mounted) {
                          context.go(RouterConstants.bottomNavBar);
                        }
                      },
                      child: Text(
                        'Explore as guest',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
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
