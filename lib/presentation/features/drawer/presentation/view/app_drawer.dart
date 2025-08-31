import 'package:flutter/material.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/utils/app_strings.dart';
import 'package:insta_food/presentation/features/drawer/presentation/cubit/drawer_cubit.dart';
import 'package:insta_food/presentation/features/drawer/presentation/view/cart_drawer.dart';
import 'package:insta_food/presentation/features/drawer/presentation/view/notifications_drawer.dart';
import 'package:insta_food/presentation/features/drawer/presentation/view/profile_drawer.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, this.drawerSelected});

  final DrawerType? drawerSelected;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      backgroundColor: AppColors.primaryOrange,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(64),
          bottomLeft: Radius.circular(64),
        ),
      ),
      child: drawerSelected == DrawerType.profile
          ? ProfileDrawer()
          : drawerSelected == DrawerType.cart
          ? CartDrawer()
          : drawerSelected == DrawerType.notifications
          ? NotificationsDrawer()
          : Center(child: Text(AppStrings.noData)),
    );
  }
}
