import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_food/core/routes/router_constants.dart';
import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/presentation/features/drawer/presentation/cubit/drawer_cubit.dart';
import 'package:insta_food/presentation/widgets/app_backbutton.dart';
import 'package:insta_food/presentation/widgets/app_search_bar.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool inableSearch;
  final bool leading;
  final String? title;
  @override
  final Size preferredSize;

  CustomAppBar({
    super.key,
    this.inableSearch = false,
    this.leading = false,
    this.title,
  }) : preferredSize = Size.fromHeight(58);

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
      title: title == null
          ? (inableSearch
                ? AppSearchBar(isEnabled: true)
                : InkWell(
                    onTap: () {
                      context.push(RouterConstants.search);
                    },
                    child: AppSearchBar(isEnabled: false),
                  ))
          : Text(title!),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 34.0),
          child: Builder(
            builder: (context) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 29),
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.read<DrawerCubit>().openDrawer(
                              DrawerType.cart,
                            );
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
              );
            },
          ),
        ),
      ],
    );
  }
}
