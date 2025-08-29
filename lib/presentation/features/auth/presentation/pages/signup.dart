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
import 'package:insta_food/core/validators/app_validator_types/mobile_number.dart';
import 'package:insta_food/core/validators/app_validator_types/date_of_birth.dart';
import 'package:insta_food/presentation/features/auth/presentation/widgets/login_screen/login_nav.dart';
import 'package:insta_food/presentation/features/auth/presentation/widgets/signup_screen/terms_and_conditions.dart';
import 'package:insta_food/presentation/features/auth/presentation/widgets/socialicons_section.dart';
import 'package:insta_food/presentation/features/auth/presentation/widgets/top_row.dart';
import 'package:insta_food/presentation/widgets/app_button_onb.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_state.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  final fullnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final mobileController = TextEditingController();
  final birthdateController = TextEditingController();
  final phonenumberController = TextEditingController();
  
  EmailAppValidator emailValidator = EmailAppValidator();
  PasswordAppValidator passwordValidator = PasswordAppValidator();
  MobileAppValidator mobileValidator = MobileAppValidator();
  DateOfBirthAppValidator dateValidator = DateOfBirthAppValidator();
  MobileAppValidator phonenumberValidator = MobileAppValidator();
  bool obscurePassword = true;

    @override
  void dispose() {
    fullnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    mobileController.dispose();
    birthdateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  TopRow(title: AppStrings.newAccount),

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

                          //full name
                          AppTextField(
                            controller: fullnameController,
                            label: AppStrings.fullName,
                            hint: AppStrings.fullNameHint,
                            keyboardType: TextInputType.name,
                          ),
                          const SizedBox(height: 16),

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
                       // Email
                            AppTextField(
                              controller: emailController,
                              label: AppStrings.email,
                              hint: AppStrings.emailHint,
                              keyboardType: TextInputType.emailAddress,
                              validator: emailValidator,
                              onChange: (value) {
                                setState(() {
                                  emailValidator.setValue(value);
                                });
                              },
                            ),

                        const SizedBox(height: 16),

                        // Mobile Number 
                            AppTextField(
                              controller: phonenumberController,
                              label: AppStrings.phone,
                              hint: AppStrings.phoneHint,
                              keyboardType: TextInputType.phone,
                              validator: phonenumberValidator,
                              onChange: (value) {
                                setState(() {
                                  phonenumberValidator.setValue(value);
                                });
                              },
                            ),

                        const SizedBox(height: 16),
                       // Date of Birth
                       AppTextField(
                         controller: birthdateController,
                         label: AppStrings.dateOfBirth,
                         hint: AppStrings.dateOfBirthHint,
                         keyboardType: TextInputType.datetime,
                         validator: dateValidator,
                         onChange: (value) {
                           setState(() {
                             dateValidator.setValue(value);
                           });
                         },
                       ),

                        // Forgot password
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
                        
                        const SizedBox(height: 16),
                        
                        // Terms and Conditions
                        const TermsAndConditions(),
                        const SizedBox(height: 16),
                        
                        // Sign Up button (changed from Log In)
                          Center(
                            child: BlocConsumer<AuthCubit, AuthState>(
                              listener: (context, state) {
                                if (state is Authenticated) {
                                  context.go(RouterConstants.bottomNavBar);
                                } else if (state is AuthError) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(state.message)),
                                  );
                                }
                              },
                              builder: (context, state) {
                                return AppButton(
                                  label: state is AuthLoading ? "Loading..." : "Sign Up",
                                  onPressed: state is AuthLoading ? null : () {
                                    if (fullnameController.text.isNotEmpty &&
                                        emailController.text.isNotEmpty &&
                                        passwordController.text.isNotEmpty &&
                                        mobileController.text.isNotEmpty &&
                                        birthdateController.text.isNotEmpty) {
                                      
                                      context.read<AuthCubit>().signUp(
                                        fullName: fullnameController.text,
                                        email: emailController.text,
                                        password: passwordController.text,
                                        dob: birthdateController.text,
                                        phone: mobileController.text,
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Please fill all fields')),
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

                          // Social Media Buttons
                          SocialIconsSection(),

                          const SizedBox(height: 10),
                          
                          //login navigation
                          LoginNav.buildLoginNav(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}