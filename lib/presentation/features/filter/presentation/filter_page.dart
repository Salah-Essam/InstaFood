import 'package:flutter/material.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/utils/app_strings.dart';
import 'package:insta_food/presentation/widgets/custom_appbar.dart';

class FilterPage extends StatelessWidget {
  const FilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryYellow,
      appBar: CustomAppBar(
        title: AppStrings.filter,
        leading: true,
        hideNotification: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: SizedBox(
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Column(),
            ),
          ),
        ),
      ),
    );
  }
}
