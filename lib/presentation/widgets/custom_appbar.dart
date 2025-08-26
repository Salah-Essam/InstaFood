import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/presentation/features/drawer/presentation/cubit/drawer_cubit.dart';
import 'package:insta_food/presentation/widgets/app_backbutton.dart';
import 'package:insta_food/presentation/widgets/app_searchinkwell.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool inableSearch;
  final bool leading;
  @override
  final Size preferredSize;

  CustomAppBar({super.key, this.inableSearch = false, this.leading = false})
    : preferredSize = Size.fromHeight(58);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.statusBar,
      leading: leading
          ? Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AppBackButton(),
              ),
            )
          : SizedBox(),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 34.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              inableSearch
                  ? SizedBox(
                      width: 200,
                      height: 25,
                      child: SearchBar(enabled: true),
                    )
                  : Searchinkwell(),
              SizedBox(width: 29),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.read<DrawerCubit>().openDrawer(DrawerType.cart);
                      },
                      child: SvgPicture.asset(
                        AppAssets.cart,
                        width: 26,
                        height: 26,
                      ),
                    ),
                    SizedBox(width: 7),
                    GestureDetector(
                      onTap: () {
                        context.read<DrawerCubit>().openDrawer(
                          DrawerType.notifications,
                        );
                      },
                      child: SvgPicture.asset(
                        AppAssets.notification,
                        width: 26,
                        height: 26,
                      ),
                    ),
                    SizedBox(width: 7),
                    GestureDetector(
                      onTap: () {
                        context.read<DrawerCubit>().openDrawer(
                          DrawerType.profile,
                        );
                      },
                      child: SvgPicture.asset(
                        AppAssets.profile,
                        width: 26,
                        height: 26,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
