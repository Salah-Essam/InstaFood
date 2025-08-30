import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_food/core/routes/router_constants.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_strings.dart';
import 'package:insta_food/core/theme/app_text_fields.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/core/validators/app_validator_types/email_validator.dart';
import 'package:insta_food/core/validators/app_validator_types/password_validator.dart';
import 'package:insta_food/presentation/features/auth/presentation/widgets/login_screen/password_reset_dialog.dart';
import 'package:insta_food/presentation/features/auth/presentation/widgets/signup_screen/signup_nav.dart';
import 'package:insta_food/presentation/features/auth/presentation/widgets/socialicons_section.dart';
import 'package:insta_food/presentation/features/auth/presentation/widgets/top_Row.dart';
import 'package:insta_food/presentation/features/auth/presentation/widgets/welcome_section.dart';
import 'package:insta_food/presentation/widgets/app_button_onb.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}


class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  EmailAppValidator emailValidator = EmailAppValidator();
  PasswordAppValidator passwordValidator = PasswordAppValidator();
  bool obscurePassword = true;
  bool _showRequired = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          context.go(RouterConstants.bottomNavBar);
        } else if (state is AuthInvalidCredentials) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        } else if (state is AuthFormValidationFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        } else if (state is AuthShouldShowPasswordReset) {
          showDialog(
            context: context,
            builder: (context) => PasswordResetDialog(email: state.email),
          );
        }
      },
      child: Scaffold(
        body: Container(
          color: AppColors.statusBar,
          child: SafeArea(
            child: Form(
              key: _formKey,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TopRow(title: AppStrings.login),
                          const SizedBox(height: 40),
                          const WelcomeSection(),
                          const SizedBox(height: 24),
                          const SizedBox(height: 16),

                          // Email
                          AppTextField(
                            controller: emailController,
                            label: AppStrings.emailOrMobile,
                            hint: AppStrings.emailExample,
                            keyboardType: TextInputType.emailAddress,
                            validator: emailValidator,
                            requiredField: true,
                            showRequiredError: _showRequired && emailController.text.isEmpty,
                            onChange: (value) {
                              setState(() {
                                emailValidator.setValue(value);
                              });
                            },
                          ),
                          const SizedBox(height: 24),

                          // Password
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

                          Center(
                            child: BlocBuilder<AuthCubit, AuthState>(
                              builder: (context, state) {
                                return AppButton(
                                  label: state is AuthLoading ? "Loading..." : "Log In",
                                  onPressed: state is AuthLoading ? null : () {
                                    setState(() { _showRequired = true; });
                                    context.read<AuthCubit>().validateLoginFields(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );
                                    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<AuthCubit>().signIn(
                                          emailController.text,
                                          passwordController.text,
                                        );
                                      }
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

                          // Social Media Buttons
                          SocialIconsSection(),

                          const SizedBox(height: 10),
                          
                          //signup navigation
                          SignupNav.buildSignupNav(context),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
    );
  }
}
