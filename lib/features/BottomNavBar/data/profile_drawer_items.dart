import 'package:insta_food/core/app_router.dart';

class ProfileDrawerItem {
  static const List<List<String>> items = [
    ['My Orders', 'assets/icons/my_orders.svg', AppRoutes.orderPage],
    ['My Profile', 'assets/icons/my_profile.svg', AppRoutes.profilePage],
    [
      'Delivery Address',
      'assets/icons/delivery_address.svg',
      AppRoutes.addressPage,
    ],
    [
      'Payment Methods',
      'assets/icons/payment_methods.svg',
      AppRoutes.paymentPage,
    ],
    ['Contact Us', 'assets/icons/contact_us.svg', AppRoutes.contactPage],
    ['Help & FAQs', 'assets/icons/help_faqs.svg', AppRoutes.helpPage],
    ['Settings', 'assets/icons/settings.svg', AppRoutes.settingsPage],
  ];
}
