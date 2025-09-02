import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_food/core/routes/router_constants.dart';

import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/core/utils/app_strings.dart';
import 'package:insta_food/presentation/features/Settings/presentation/widgets/password_setting_text_field.dart';
import 'package:insta_food/presentation/widgets/app_button_onb.dart';
import 'package:insta_food/presentation/widgets/shared_scaffold.dart';

class PasswrodSettingPage extends StatelessWidget {
  const PasswrodSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      appBarTitle: "Passwrod Setting",
      pageDetails: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Column(
            children: [
              PasswordSettingTextField(
                controller: currentController,
                title: "Current Password",
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    context.push(RouterConstants.forgotPassword);
                  },
                  child: Text(
                    AppStrings.forgetPassword,
                    style: AppTextStyles.forgetPassword,
                  ),
                ),
              ),

              SizedBox(height: 16),

              PasswordSettingTextField(
                controller: newpasswordController,
                title: "New Password",
              ),
              SizedBox(height: 16),
              PasswordSettingTextField(
                controller: confirmpasswordController,
                title: "Confirm New Password",
              ),
              Center(
                child: Padding(
                  padding: EdgeInsetsGeometry.only(top: 200, bottom: 32),
                  child: AppButton(
                    onPressed: () {},
                    width: 150,
                    height: 30,
                    borderRadius: 24,
                    child: Text(
                      "Change Password",
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

final TextEditingController currentController = TextEditingController();
final TextEditingController newpasswordController = TextEditingController();
final TextEditingController confirmpasswordController = TextEditingController();
