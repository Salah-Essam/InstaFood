import 'package:insta_food/core/routes/router_constants.dart';
import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/core/utils/app_strings.dart';
import 'package:insta_food/presentation/features/drawer/data/model/profile_dawer_item_model.dart';

class ProfileDrawerData {
  static final List<ProfileDawerItemModel> items = [
    ProfileDawerItemModel(
      name: AppStrings.myOrders,
      icon: AppAssets.myOrders,
      pagePath: RouterConstants.orderPage,
    ),
    ProfileDawerItemModel(
      name: AppStrings.myProfile,
      icon: AppAssets.profile,
      pagePath: RouterConstants.profilePage,
    ),
    ProfileDawerItemModel(
      name: AppStrings.deliveryAddress,
      icon: AppAssets.deliveryAddress,
      pagePath: RouterConstants.addressPage,
    ),
    ProfileDawerItemModel(
      name: AppStrings.paymentMethods,
      icon: AppAssets.payment,
      pagePath: RouterConstants.paymentPage,
    ),
    ProfileDawerItemModel(
      name: AppStrings.contactUs,
      icon: AppAssets.contactUs,
      pagePath: RouterConstants.helpFAQsPage2,
    ),
    ProfileDawerItemModel(
      name: AppStrings.helpFAQs,
      icon: AppAssets.helpFAQs,
      pagePath: RouterConstants.helpFAQsPage1,
    ),
    ProfileDawerItemModel(
      name: AppStrings.settings,
      icon: AppAssets.settings,
      pagePath: RouterConstants.settingsPage,
    ),
    ProfileDawerItemModel(name: "Log Out", icon: AppAssets.logout),
  ];
}
