import 'package:insta_food/core/app_router.dart';

class ProfileDrawerItem {
  static const List<List<String>> items = [
    ['My Orders', 'assets/icons/my_orders.svg', AppRoutes.orderPageRouteName],
    [
      'My Profile',
      'assets/icons/my_profile.svg',
      AppRoutes.profilePageRouteName,
    ],
    [
      'Delivery Address',
      'assets/icons/delivery_address.svg',
      AppRoutes.addressPageRouteName,
    ],
    [
      'Payment Methods',
      'assets/icons/payment_methods.svg',
      AppRoutes.paymentPageRouteName,
    ],
    [
      'Contact Us',
      'assets/icons/contact_us.svg',
      AppRoutes.contactPageRouteName,
    ],
    ['Help & FAQs', 'assets/icons/help_faqs.svg', AppRoutes.helpPageRouteName],
    ['Settings', 'assets/icons/settings.svg', AppRoutes.settingsPageRouteName],
  ];
}
