import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
  final String? email; // Email for password reset by email
  
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
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: state.message.contains('successfully') ? Colors.green : Colors.red,
            ),
          );
          // If password was updated successfully, navigate to login
          if (state.message.contains('successfully')) {
            context.go('/login');
          }
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
                        
                        // Password
                        AppTextField(
                          controller: passwordController,
                          label: AppStrings.password,
                          hint: AppStrings.passwordHint,
                          obscureText: obscurePassword,
                          validator: passwordValidator,
                          onChange: (value) {
                            setState(() {
                              passwordValidator.setValue(value);
                            });
                          },
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Confirm Password
                        AppTextField(
                          controller: confirmPasswordController,
                          label: AppStrings.confirmPassword,
                          hint: AppStrings.confirmPasswordHint,
                          obscureText: obscureConfirmPassword,
                          validator: confirmPasswordValidator,
                          onChange: (value) {
                            setState(() {
                              confirmPasswordController.text = value;
                            });
                          },
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscureConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                obscureConfirmPassword = !obscureConfirmPassword;
                              });
                            },
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Submit Button
                           Center(
                            child: BlocConsumer<AuthCubit, AuthState>(
                              listener: (context, state) {
                                if (state is Authenticated) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Password updated successfully')),
                                  );
                                  Navigator.of(context).pop();
                                } else if (state is AuthError) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(state.message)),
                                  );
                                }
                              },
                              builder: (context, state) {
                                return AppButton(
                                  label: state is AuthLoading ? "Loading..." : "Create New Password",
                                  onPressed: state is AuthLoading ? null : () {
                                    if (passwordController.text.isNotEmpty &&
                                        passwordController.text == confirmPasswordController.text) {
                                      // Check if this is a password reset by email or regular password change
                                      if (widget.email != null) {
                                        // Password reset by email
                                        context.read<AuthCubit>().changePasswordByEmail(
                                          widget.email!,
                                          passwordController.text,
                                        );
                                      } else {
                                        // Regular password change (user is logged in)
                                        context.read<AuthCubit>().setPassword(passwordController.text);
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Passwords do not match or are empty')),
                                      );
                                    }
                                  },
                                  height: 48.0,
                                  borderRadius: 28,
                                  width: MediaQuery.of(context).size.width * 0.5,
                                  backgroundColor: AppColors.primary,
                                  textStyle: AppTextStyles.login,
                                );
                              },
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