import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_food/core/routes/router_constants.dart';
import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/presentation/widgets/app_backbutton.dart';
import 'package:insta_food/presentation/widgets/app_searchBar.dart';
import 'package:insta_food/presentation/widgets/app_searchinkwell.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool inableSearch;
  final bool leading;
  @override
  final Size preferredSize;

  CustomAppBar({Key? key, this.inableSearch = false, this.leading = false})
    : preferredSize = Size.fromHeight(58),
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.statusBar,
      leading: leading
          ? Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 30.0, bottom: 8),
                child: AppBackButton(),
              ),
            )
          : SizedBox(),
      actions: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(right: 34.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                inableSearch ? searchBar(enabled: true) : Searchinkwell(),
                SizedBox(width: 29),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          ;
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
                          ;
                        },
                        child: SvgPicture.asset(
                          AppAssets.notification,
                          width: 26,
                          height: 26,
                        ),
                      ),
                      SizedBox(width: 7),
                      GestureDetector(
                        onTap: () {},
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
        ),
      ],
    );
  }
}
