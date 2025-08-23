import 'package:flutter/material.dart';
import 'package:insta_food/core/app_colors.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, required this.drawerContent});

  final Widget drawerContent;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      backgroundColor: AppColors.orangeBase,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(64),
          bottomLeft: Radius.circular(64),
        ),
      ),
      child: drawerContent,
    );
  }
}
