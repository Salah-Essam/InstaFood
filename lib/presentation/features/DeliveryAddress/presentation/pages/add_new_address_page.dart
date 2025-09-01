import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/presentation/features/drawer/presentation/widgets/app_text_field_drawer.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/presentation/widgets/app_button_onb.dart';
import 'package:insta_food/presentation/widgets/shared_scaffold.dart';

class AddNewAddressPage extends StatelessWidget {
  AddNewAddressPage({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      appBarTitle: "Add New Address",
      pageDetails: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Center(
                  child: SvgPicture.asset(
                    AppAssets.navBarHome,
                    colorFilter: ColorFilter.mode(
                      AppColors.primaryOrange,
                      BlendMode.srcIn,
                    ),
                    height: 75,
                    width: 75,
                  ),
                ),
              ),
              SizedBox(height: 32),
              Text("Full Name", style: AppTextStyles.header),
              SizedBox(height: 8),
              AppTextFieldDrawer(
                controller: nameController,
                onChange: (p0) {},
                maxLines: 1,
                maxLength: 30,
              ),
              SizedBox(height: 24),
              Text("Date of Birth", style: AppTextStyles.header),
              SizedBox(height: 8),
              AppTextFieldDrawer(
                controller: addressController,
                onChange: (p0) {},
                maxLines: 2,
                maxLength: 60,
              ),

              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 64),
                  child: AppButton(
                    onPressed: () {},
                    backgroundColor: AppColors.primaryOrange,
                    width: 130,
                    height: 30,
                    borderRadius: 24,
                    child: Text(
                      "Apply",
                      style: AppTextStyles.fontWhiteSmallBold,
                    ),
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
