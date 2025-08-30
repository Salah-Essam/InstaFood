import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_strings.dart';
import 'package:insta_food/core/theme/app_text_fields.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/core/validators/app_validator_types/confirm_password_validator.dart';
import 'package:insta_food/core/validators/app_validator_types/password_validator.dart';
import 'package:insta_food/presentation/features/auth/presentation/widgets/top_row.dart';
import 'package:insta_food/presentation/widgets/app_button_onb.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_state.dart';


class SetPasswordPage extends StatefulWidget {
  final String? email; // Target email for password reset

  const SetPasswordPage({super.key, this.email});

  @override
  SetPasswordPageState createState() => SetPasswordPageState();
}

class SetPasswordPageState extends State<SetPasswordPage> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  PasswordAppValidator passwordValidator = PasswordAppValidator();
  ConfirmPasswordAppValidator confirmPasswordValidator = ConfirmPasswordAppValidator();
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool _showRequired = false; 

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is PasswordResetEmailSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Password reset email sent to ${state.email}'),
              backgroundColor: AppColors.success,
            ),
          );
        } else if (state is PasswordResetEmailFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.statusBar,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
        child: Column(
          children: [
            // Yellow section with Hello and back button
            Container(
              color: AppColors.statusBar,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 32),

                    // Back button and Hello text
                    TopRow(title: AppStrings.setPassword),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // Content section
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                          style: TextStyle(
                            color: AppColors.darkBrown,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                        AppTextField(
                          controller: passwordController,
                          label: AppStrings.password,
                          hint: AppStrings.passwordHint,
                          obscureText: obscurePassword,
                          validator: passwordValidator,
                          requiredField: true,
                          showRequiredError: _showRequired && passwordController.text.isEmpty,
                          onChange: (value) {
                            setState(() {
                              passwordValidator.setValue(value);
                              confirmPasswordValidator.comparedWithPassword = value;
                            });
                          },
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            onPressed: () { setState(() { obscurePassword = !obscurePassword; }); },
                          ),
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: confirmPasswordController,
                          label: AppStrings.confirmPassword,
                          hint: AppStrings.confirmPasswordHint,
                          obscureText: obscureConfirmPassword,
                          validator: confirmPasswordValidator,
                          requiredField: true,
                          showRequiredError: _showRequired && confirmPasswordController.text.isEmpty,
                          onChange: (value) {
                            setState(() {
                              confirmPasswordController.text = value;
                            });
                          },
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            onPressed: () { setState(() { obscureConfirmPassword = !obscureConfirmPassword; }); },
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Submit Button
                           Center(
                            child: BlocBuilder<AuthCubit, AuthState>(
                              builder: (context, state) {
                                return AppButton(
                                  label: state is AuthLoading ? 'Sending...' : 'Send Reset Email',
                                  onPressed: state is AuthLoading ? null : () {
                                    final targetEmail = widget.email;
                                    if (targetEmail == null || targetEmail.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: const Text('No email provided for reset'),
                                          backgroundColor: AppColors.error,
                                        ),
                                      );
                                      return;
                                    }
                                    context.read<AuthCubit>().changePasswordByEmail(targetEmail);
                                  },
                                  height: 48.0,
                                  borderRadius: 28,
                                  width: MediaQuery.of(context).size.width * 0.6,
                                  backgroundColor: AppColors.primary,
                                  textStyle: AppTextStyles.login,
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Create New Password validation-only button
                          Center(
                            child: AppButton(
                              label: 'Create New Password',
                              onPressed: () {
                                setState(() { _showRequired = true; });
                                passwordValidator.setValue(passwordController.text);
                                confirmPasswordValidator.setValue(confirmPasswordController.text);
                                confirmPasswordValidator.comparedWithPassword = passwordController.text;
                                final passErrors = passwordValidator.check();
                                final confirmErrors = confirmPasswordValidator.check();
                                if (passwordController.text.isNotEmpty &&
                                    confirmPasswordController.text.isNotEmpty &&
                                    passErrors.isEmpty && confirmErrors.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Password fields valid'), backgroundColor: AppColors.success),
                                  );
                                }
                              },
                              height: 48.0,
                              borderRadius: 28,
                              width: MediaQuery.of(context).size.width * 0.6,
                              backgroundColor: AppColors.primary,
                              textStyle: AppTextStyles.login,
                            ),
                          ),
                      ],
                    ),
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