import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_food/core/routes/router_constants.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/core/utils/app_alerts.dart';
import 'package:insta_food/core/utils/app_strings.dart';
import 'package:insta_food/presentation/features/Profile/presentation/cubit/ProfileImageCubit/profile_image_cubit.dart';
import 'package:insta_food/presentation/features/drawer/data/datasources/profile_drawer_data.dart';
import 'package:insta_food/presentation/features/drawer/presentation/widgets/drawer_item.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_state.dart';
import 'package:insta_food/presentation/widgets/app_button_onb.dart';

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
                        backgroundColor: AppColors.primaryYellow,
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
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    String name = 'Guest';
                    String email = '';
                    if (state is Authenticated) {
                      name = state.user.fullName.isNotEmpty
                          ? state.user.fullName
                          : 'User';
                      email = state.user.email;
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            color: AppColors.textLight,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (email.isNotEmpty)
                          Text(
                            email,
                            style: TextStyle(
                              color: AppColors.lightOrange,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is Authenticated) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => DrawerItem(
                      onTap: () {
                        if (ProfileDrawerData.items[index].pagePath != null) {
                          context.push(
                            "${ProfileDrawerData.items[index].pagePath}",
                          );
                        } else {
                          AppAlerts.showLogoutAppDialog(
                            context,
                            title: AppStrings.areYouSureYouWantYoLogout,
                          );
                        }
                      },
                      label: ProfileDrawerData.items[index].name,
                      icon: ProfileDrawerData.items[index].icon,
                    ),
                    separatorBuilder: (context, index) => Divider(
                      color: AppColors.lightOrange,
                      thickness: 1,
                      height: 24,
                    ),
                    itemCount: ProfileDrawerData.items.length,
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(top: 128),
                    child: Center(
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // يخليهم في النص رأسيًا
                        crossAxisAlignment:
                            CrossAxisAlignment.center, // يخليهم في النص أفقيًا
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Please sign in first to see",
                            style: TextStyle(
                              color: AppColors.textLight,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          AppButton(
                            borderRadius: 24,
                            backgroundColor: AppColors.loginButton,

                            onPressed: () {
                              context.go(RouterConstants.secondSplash);
                            },
                            child: Text(
                              "Go to Sign In",
                              style: AppTextStyles.dialogTitle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
