import 'package:flutter/material.dart';

class AppColors {
  // Brand colors
  static const Color primary = Color(
    0xFFE95322,
  ); // buttons, accents, skip button
  static const Color statusBar = Color(0xFFF5CB58); // status bar background
  static const Color sheetBg = Colors.white; // bottom rounded sheet
  static const Color sheetShadow = Color(0x1A000000); // 10% black

  // Splash screen
  static const Color splashBackground = Color(
    0xFFF5CB58,
  ); // Exact Figma yellow color

  // Second splash screen (orange)
  static const Color secondSplashBackground = Color(
    0xFFE95322,
  ); // Orange background
  static const Color loginButtonBackground = Color(
    0xFFF5CB58,
  ); // Login button color
  static const Color signupButtonBackground = Color(
    0xFFF3E9B5,
  ); // Signup button color
  static const Color buttonTextColor = Color(
    0xFF452521,
  ); // Dark orange/brown text inside buttons

  // Text
  static const Color title = Color(0xFF101828);
  static const Color body = Color(0xFF475467);

  // Status bar text and icons
  static const Color statusBarContent = Color(0xFF000000);

  static var orangeBase = Colors.orange;

  static var white = Colors.white;
  static var lightYellow = Color(0xFFF3E9B5);

  static var fontWhite = Color(0xFFF8F8F8);

  static var grey = Color(0xFF4E5457);

  static var darktext = Color(0xFF452521);

  // Legacy aliases used across the app (kept for compatibility)
  static const Color orange2 = Color(
    0xFFFFD699,
  ); // light orange for text/dividers
  static const Color yellowBase = Color(0xFFF5CB58);
  static const Color yellow2 = Color(0xFFF3E9B5);
}
