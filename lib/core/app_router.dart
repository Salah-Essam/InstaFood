import 'package:flutter/material.dart';
import 'package:insta_food/features/BottomNavBar/presentation/pages/bottom_nav_bar.dart';
import 'package:insta_food/home_page.dart';

class AppRouter {
  Map<String, WidgetBuilder> getRoutes(BuildContext context) {
    return {
      AppRoutes.bottomNavBarRouteName: (context) => const BottomNavBar(),
      AppRoutes.homePageRouteName: (context) => const HomePage(),
    };
  }
}

class AppRoutes {
  static const String bottomNavBarRouteName = '/bottom_nav_bar';
  static const String homePageRouteName = '/home_page';
  static const String orderPageRouteName = '/order_page';
  static const String profilePageRouteName = '/profile_page';
  static const String addressPageRouteName = '/address_page';
  static const String paymentPageRouteName = '/payment_page';
  static const String contactPageRouteName = '/contact_page';
  static const String helpPageRouteName = '/help_page';
  static const String settingsPageRouteName = '/settings_page';
}
