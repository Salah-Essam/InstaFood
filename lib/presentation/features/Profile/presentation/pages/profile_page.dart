import 'package:flutter/material.dart';
import 'package:insta_food/core/theme/app_colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.yellowBase,
      body: Column(
        children: [
          SizedBox(height: size.height * 0.15, width: double.infinity),
          SizedBox(
            width: double.infinity,
            height: size.height * 0.85,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: SingleChildScrollView(child: Column(children: [
                  ],
                )),
            ),
          ),
        ],
      ),
    );
  }
}
