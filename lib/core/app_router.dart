import 'package:flutter/material.dart';
import 'package:insta_food/features/BottomNavBar/presentation/pages/bottom_nav_bar.dart';
import 'package:insta_food/features/Profile/presentation/pages/profile_page.dart';
import 'package:insta_food/home_page.dart';

class AppRouter {
  Map<String, WidgetBuilder> getRoutes(BuildContext context) {
    return {
      AppRoutes.bottomNavBar: (context) => BottomNavBar(),
      AppRoutes.homePage: (context) => const HomePage(),
      AppRoutes.profilePage: (context) => ProfilePage(),
    };
  }
}

class AppRoutes {
  static const String bottomNavBar = '/bottom_nav_bar';
  static const String homePage = '/home_page';
  static const String orderPage = '/order_page';
  static const String profilePage = '/profile_page';
  static const String addressPage = '/address_page';
  static const String paymentPage = '/payment_page';
  static const String contactPage = '/contact_page';
  static const String helpPage = '/help_page';
  static const String settingsPage = '/settings_page';
}
