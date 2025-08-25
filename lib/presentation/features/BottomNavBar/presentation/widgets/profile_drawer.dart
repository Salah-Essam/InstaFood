import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_food/core/routes/router.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/presentation/features/BottomNavBar/data/profile_drawer_items.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.person, color: Colors.black, size: 30),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Username',
                      style: TextStyle(
                        color: AppColors.fontWhite,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // SizedBox(height: 4),
                    Text(
                      'user@example.com',
                      style: TextStyle(color: AppColors.orange2, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),

            Column(
              children: List.generate(ProfileDrawerItem.items.length, (item) {
                return Column(
                  children: [
                    DrawerItem(
                      onTap: () {
                        // Navigator.pushNamed(context, AppRoutes.profilePage);
                        context.go(Routes.profilePage);
                      },
                      label: ProfileDrawerItem.items[item][0],
                      icon: ProfileDrawerItem.items[item][1],
                    ),
                    Divider(color: AppColors.orange2, thickness: 1, height: 24),
                  ],
                );
              }),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DrawerItem(
                onTap: () {},
                label: 'Logout',
                icon: 'assets/icons/logout.svg',
                iconHeight: 24,
                iconWidth: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.iconWidth,
    this.iconHeight,
    this.fontSize,
  });
  final String label;
  final String icon;
  final VoidCallback onTap;
  final double? iconWidth;
  final double? iconHeight;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            width: iconWidth ?? 32,
            height: iconHeight ?? 32,
          ),
          const SizedBox(width: 16),
          Text(
            label,
            style: TextStyle(
              color: AppColors.orange2,
              fontSize: fontSize ?? 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
