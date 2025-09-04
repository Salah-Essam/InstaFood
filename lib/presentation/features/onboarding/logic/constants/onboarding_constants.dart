class OnboardingConstants {
  // Animation durations
  static const Duration pageTransitionDuration = Duration(milliseconds: 350);
  static const Duration bottomSheetAnimationDuration = Duration(
    milliseconds: 300,
  );

  // Page count
  static const int totalPages = 3;

  // Page indices
  static const int firstPageIndex = 0;
  static const int secondPageIndex = 1;
  static const int lastPageIndex = 2;

  // Asset paths
  static const String transferDocumentIcon ='assets/images/Transfer_Document_icon.png';
  static const String cardIcon = 'assets/icons/Card_icon.svg';
  static const String deliverBoyIcon = 'assets/icons/Deliver_Boy_Icon.svg';

  // Image paths
  static const String firstPageImage = 'assets/images/onboarding1.png';
  static const String secondPageImage = 'assets/images/onboarding2.png';
  static const String thirdPageImage = 'assets/images/onboarding3.png';

  // Content
  static const String firstPageTitle = 'Order For Food';
  static const String secondPageTitle = 'Easy Payment';
  static const String thirdPageTitle = 'Fast Delivery';
  static const String pageBody =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna.';

  // UI Dimensions
  static const double bottomSheetHeight = 338.0;
  static const double iconSize = 48.0;
  static const double buttonWidth = 133.0;
  static const double buttonHeight = 36.0;
  static const double buttonBorderRadius = 24.0;
  static const double pageIndicatorDotHeight = 6.0;
  static const double pageIndicatorDotWidth = 16.0;
  static const double pageIndicatorSpacing = 8.0;
}
