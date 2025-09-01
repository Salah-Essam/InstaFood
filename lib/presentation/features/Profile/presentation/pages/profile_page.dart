import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/presentation/features/Profile/presentation/cubit/ProfileImageCubit/profile_image_cubit.dart';
import 'package:insta_food/presentation/widgets/app_button_onb.dart';
import 'package:insta_food/presentation/features/drawer/presentation/widgets/app_text_field_drawer.dart';
import 'package:insta_food/presentation/widgets/shared_scaffold.dart';
import 'package:intl/intl.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_state.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthCubit>().state;
    if (state is Authenticated) {
      nameController.text = state.user.fullName;
      emailController.text = state.user.email;
      phoneController.text = state.user.phone;
      dateController.text = state.user.dateOfBirth.isNotEmpty
          ? state.user.dateOfBirth
          : DateFormat("dd/MM/yyyy").format(DateTime.now());
    }
    return SharedScaffold(
      appBarTitle: "MyProfile",
      pageDetails: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Center(
                  child: SizedBox(
                    child: BlocProvider(
                      create: (_) => ProfileImageCubit()..loadImage(),
                      child: BlocBuilder<ProfileImageCubit, ProfileImageState>(
                        builder: (context, state) {
                          String? imagePath;
                          if (state is ProfileImageLoaded) {
                            imagePath = state.imagePath;
                          }
                          return Stack(
                            children: [
                              SizedBox(height: 130, width: 130),
                              SizedBox(
                                height: 125,
                                width: 125,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: AppColors.lightOrange,
                                    borderRadius: BorderRadius.circular(24),
                                  ),

                                  child: ClipRRect(
                                    borderRadius: BorderRadiusGeometry.circular(
                                      24,
                                    ),
                                    child: imagePath != null
                                        ? Image.file(
                                            File(imagePath),
                                            fit: BoxFit.cover,
                                          )
                                        : Icon(Icons.person, size: 50),
                                  ),
                                  // Icon(Icons.person, size: 50),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: InkWell(
                                  onTap: () {
                                    context
                                        .read<ProfileImageCubit>()
                                        .pickImage();
                                  },
                                  child: SvgPicture.asset(
                                    AppAssets.camera,
                                    width: 30,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32),
              Text("Full Name", style: AppTextStyles.header),
              SizedBox(height: 8),
              AppTextFieldDrawer(controller: nameController, onChange: (p0) {}),
              SizedBox(height: 24),
              Text("Date of Birth", style: AppTextStyles.header),
              SizedBox(height: 8),
              AppTextFieldDrawer(controller: dateController, onChange: (p0) {}),
              SizedBox(height: 24),
              Text("Email", style: AppTextStyles.header),
              SizedBox(height: 8),
              AppTextFieldDrawer(
                controller: emailController,
                onChange: (p0) {},
              ),
              SizedBox(height: 24),
              Text("Phone Number", style: AppTextStyles.header),
              SizedBox(height: 8),
              AppTextFieldDrawer(
                controller: phoneController,
                onChange: (p0) {},
              ),
              SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.only(top: 32, bottom: 16),
                child: Center(
                  child: AppButton(
                    onPressed: () {},
                    label: "Update Profile",
                    textStyle: AppTextStyles.button,
                    borderRadius: 24,
                    width: 150,
                    height: 35,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
