import 'package:flutter/material.dart';

class AppColors {
  // ================= Brand / Primary Colors =================
  static const Color primaryOrange = Color(0xFFE95322); // Main brand orange
  static const Color primaryYellow = Color(0xFFF5CB58); // Main brand yellow

  // ================= Backgrounds =================
  static const Color splashYellow = primaryYellow; // Splash screen yellow
  static const Color splashOrange = primaryOrange; // Splash screen orange
  static const Color sheetBackground = Colors.white; // Bottom sheet background
  static const Color sheetShadow = Color(0x1A000000); // 10% black

  // ================= Buttons =================
  static const Color loginButton = primaryYellow; // Login button background
  static const Color signupButton = Color(
    0xFFF3E9B5,
  ); // Light yellow for signup
  static const Color buttonText = Color(0xFF452521); // Dark brown button text

  // ================= Text =================
  static const Color textPrimary = Color(0xFF101828); // Titles
  static const Color textSecondary = Color(0xFF475467); // Body text
  static const Color textLight = Color(0xFFF8F8F8); // White-ish font
  static const Color textDarkBrown = Color(0xFF452521); // Dark brown text

  // ================= Status Bar =================
  static const Color statusBarBg = primaryYellow; // Status bar background
  static const Color statusBarContent = Color(0xFF000000); // Black icons/text

  // ================= Neutrals =================
  static const Color white = Colors.white;
  static const Color grey = Color(0xFF4E5457);

  // ================= Legacy / Extra =================
  static const Color lightOrange = Color(0xFFFFDECF); // Pale orange (dividers)
  static const Color lightYellow = Color(0xFFF3E9B5); // Soft yellow
  static const Color border = Color(0xFFF1CCBC); // Light brown border
  static const Color deepBrown = Color(0xFF391713); // Very dark brown
  static const Color blackish = Color(0xFF252525); // Almost black

  // ================= Status =================
  static const Color error = Color(0xFFFF0000); // Bright red
  static const Color success = Color(0xFF00AA00); // Bright green
}
