import 'package:insta_food/core/routes/router_constants.dart';
import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/presentation/features/drawer/data/model/profile_dawer_item_model.dart';

class ProfileDrawerData {
  static final List<ProfileDawerItemModel> items = [
    ProfileDawerItemModel(
      name: "My Orders",
      icon: AppAssets.myOrders,
      pagePath: RouterConstants.orderPage,
    ),
    ProfileDawerItemModel(
      name: "My Profile",
      icon: AppAssets.profile,
      pagePath: RouterConstants.profilePage,
    ),
    ProfileDawerItemModel(
      name: "DeliveryAddress",
      icon: AppAssets.deliveryAddress,
      pagePath: RouterConstants.addressPage,
    ),
    ProfileDawerItemModel(
      name: "Payment Methods",
      icon: AppAssets.payment,
      pagePath: RouterConstants.paymentPage,
    ),
    ProfileDawerItemModel(
      name: "Contact Us",
      icon: AppAssets.contactUs,
      pagePath: RouterConstants.contactPage,
    ),
    ProfileDawerItemModel(
      name: "Help & FAQs",
      icon: AppAssets.helpFAQs,
      pagePath: RouterConstants.helpPage,
    ),
    ProfileDawerItemModel(
      name: "Settings",
      icon: AppAssets.settings,
      pagePath: RouterConstants.settingsPage,
    ),
    ProfileDawerItemModel(name: "Log Out", icon: AppAssets.logout),
  ];
}
