import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_food/core/routes/router_constants.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_state.dart';
import 'package:insta_food/presentation/features/drawer/presentation/cubit/drawer_cubit.dart';
import 'package:insta_food/presentation/features/drawer/presentation/view/cart_drawer.dart';
import 'package:insta_food/presentation/features/drawer/presentation/view/notifications_drawer.dart';
import 'package:insta_food/presentation/features/drawer/presentation/view/profile_drawer.dart';
import 'package:insta_food/presentation/widgets/app_button_onb.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, this.drawerSelected});

  final DrawerType? drawerSelected;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      backgroundColor: AppColors.primaryOrange,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(64),
          bottomLeft: Radius.circular(64),
        ),
      ),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return drawerSelected == DrawerType.profile
                ? ProfileDrawer()
                : drawerSelected == DrawerType.cart
                ? CartDrawer()
                : drawerSelected == DrawerType.notifications
                ? NotificationsDrawer()
                : ProfileDrawer();
          } else {
            return Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Please sign in first to see",
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      borderRadius: 24,
                      backgroundColor: AppColors.loginButton,

                      onPressed: () {
                        context.go(RouterConstants.secondSplash);
                      },
                      child: Text(
                        "Go to Sign In",
                        style: AppTextStyles.dialogTitle,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
