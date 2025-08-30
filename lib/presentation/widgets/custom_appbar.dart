import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/presentation/features/drawer/presentation/cubit/drawer_cubit.dart';
import 'package:insta_food/presentation/features/search/presentation/search_page.dart';
import 'package:insta_food/presentation/widgets/app_search_bar.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool inableSearch;
  final bool leading;
  final String? title;
  final bool hideNotification;
  @override
  final Size preferredSize;

  CustomAppBar({
    super.key,
    this.inableSearch = false,
    this.leading = false,
    this.title,
    this.hideNotification = false,
  }) : preferredSize = Size.fromHeight(69);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 8),
      child: AppBar(
        backgroundColor: AppColors.statusBar,
        scrolledUnderElevation: 0.0,
        toolbarHeight: 58,
        leading: leading
            ? Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: InkWell(
                    child: SvgPicture.asset(
                      AppAssets.backArrow,
                      fit: BoxFit.fill,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              )
            : SizedBox(),
        leadingWidth: 40,
        title: title == null
            ? (inableSearch
                  ? AppSearchBar(isEnabled: true)
                  : InkWell(
                      onTap: () {
                        pushScreen(
                          context,
                          screen: SearchPage(),
                          withNavBar: true,
                        );
                      },
                      child: AppSearchBar(isEnabled: false),
                    ))
            : Text(title!, style: AppTextStyles.pageTitle),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 34.0),
            child: Builder(
              builder: (context) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
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
                    ?hideNotification
                        ? null
                        : GestureDetector(
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
                    ?hideNotification ? null : SizedBox(width: 7),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
