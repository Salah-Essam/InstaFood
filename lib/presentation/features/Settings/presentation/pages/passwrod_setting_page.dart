import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_food/core/routes/router_constants.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_fields.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/core/utils/app_strings.dart';
import 'package:insta_food/core/validators/app_validator_types/password_validator.dart';
import 'package:insta_food/presentation/widgets/app_button_onb.dart';
import 'package:insta_food/presentation/widgets/shared_scaffold.dart';

class PasswrodSettingPage extends StatefulWidget {
  const PasswrodSettingPage({super.key});

  @override
  State<PasswrodSettingPage> createState() => _PasswrodSettingPageState();
}

final TextEditingController passwordController = TextEditingController();
bool obscurePassword = true;
bool _showRequired = false;
final PasswordAppValidator passwordValidator = PasswordAppValidator();

class _PasswrodSettingPageState extends State<PasswrodSettingPage> {
  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      appBarTitle: "Passwrod Setting",
      pageDetails: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Column(
            children: [
              AppTextField(
                controller: passwordController,
                label: "Current Password",
                hint: AppStrings.passwordHint,
                obscureText: obscurePassword,
                validator: passwordValidator,
                requiredField: true,
                showRequiredError:
                    _showRequired && passwordController.text.isEmpty,
                onChange: (value) {
                  setState(() {
                    passwordValidator.setValue(value);
                  });
                },
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.primaryOrange,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                ),
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
              AppTextField(
                controller: passwordController,
                label: "New Password",
                hint: AppStrings.passwordHint,
                obscureText: obscurePassword,
                validator: passwordValidator,
                requiredField: true,
                showRequiredError:
                    _showRequired && passwordController.text.isEmpty,
                onChange: (value) {
                  setState(() {
                    passwordValidator.setValue(value);
                  });
                },
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.primaryOrange,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                ),
              ),
              SizedBox(height: 16),
              AppTextField(
                controller: passwordController,
                label: "Confirm New Password",
                hint: AppStrings.passwordHint,
                obscureText: obscurePassword,
                validator: passwordValidator,
                requiredField: true,
                showRequiredError:
                    _showRequired && passwordController.text.isEmpty,
                onChange: (value) {
                  setState(() {
                    passwordValidator.setValue(value);
                  });
                },
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.primaryOrange,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                ),
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
