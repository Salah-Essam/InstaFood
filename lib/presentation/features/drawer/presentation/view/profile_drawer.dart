import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_food/core/routes/router_constants.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/presentation/features/drawer/data/datasources/profile_drawer_data.dart';
import 'package:insta_food/presentation/features/drawer/presentation/widgets/drawer_item.dart';

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
                  backgroundColor: AppColors.statusBar,
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
              children: List.generate(ProfileDrawerData.items.length, (index) {
                return Column(
                  children: [
                    DrawerItem(
                      onTap: () {
                        context.push(RouterConstants.profilePage);
                      },
                      label: ProfileDrawerData.items[index].name,
                      icon: ProfileDrawerData.items[index].icon,
                    ),
                    Divider(color: AppColors.orange2, thickness: 1, height: 24),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
