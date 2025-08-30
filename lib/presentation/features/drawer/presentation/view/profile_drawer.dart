import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/utils/app_alerts.dart';
import 'package:insta_food/presentation/features/Profile/presentation/cubit/ProfileImageCubit/profile_image_cubit.dart';
import 'package:insta_food/presentation/features/drawer/data/datasources/profile_drawer_data.dart';
import 'package:insta_food/presentation/features/drawer/presentation/widgets/drawer_item.dart';
import 'package:insta_food/presentation/features/auth/presentation/widgets/logout_confirmation_dialog.dart';

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
                BlocProvider(
                  create: (context) => ProfileImageCubit()..loadImage(),
                  child: BlocBuilder<ProfileImageCubit, ProfileImageState>(
                    builder: (context, state) {
                      String? imagePath;
                      if (state is ProfileImageLoaded) {
                        imagePath = state.imagePath;
                      }
                      return CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.statusBar,
                        backgroundImage: imagePath != null
                            ? FileImage(File(imagePath))
                            : null,
                        child: imagePath == null
                            ? Icon(Icons.person, color: Colors.black, size: 30)
                            : null,
                      );
                    },
                  ),
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
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => DrawerItem(
                onTap: () {
                  if (ProfileDrawerData.items[index].pagePath != null) {
                    context.push("${ProfileDrawerData.items[index].pagePath}");
                  } else {
                    AppAlerts.showLogoutAppDialog(
                      context,
                      title: "Are you sure you want to log out?",
                    );
                  }
                },
                label: ProfileDrawerData.items[index].name,
                icon: ProfileDrawerData.items[index].icon,
              ),
              separatorBuilder: (context, index) =>
                  Divider(color: AppColors.orange2, thickness: 1, height: 24),
              itemCount: ProfileDrawerData.items.length,
            ),
          ],
        ),
      ),
    );
  }
}
