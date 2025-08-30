import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/core/utils/app_strings.dart';
import 'package:insta_food/presentation/features/filter/presentation/filter_page.dart';
import 'package:insta_food/presentation/features/items/presentation/cubit/item_cubit.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class AppSearchBar extends StatelessWidget {
  const AppSearchBar({super.key, required this.isEnabled});
  final bool isEnabled;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 26,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        color: AppColors.sheetBg,
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                enabled: isEnabled,
                onChanged: (v) {
                  context.read<ItemCubit>().searchItem(v);
                },
                cursorHeight: 14,
                cursorColor: AppColors.primary,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: AppStrings.search,
                  hintStyle: AppTextStyles.search,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 16,
                  ),

                  isDense: true,
                  disabledBorder: InputBorder.none,
                ),
              ),
            ),
            isEnabled
                ? InkWell(
                    onTap: () {
                      pushScreen(
                        context,
                        screen: FilterPage(),
                        withNavBar: true,
                      );
                    },
                    child: SvgPicture.asset(
                      AppAssets.filter,
                      height: 20,
                      width: 20,
                      fit: BoxFit.cover,
                    ),
                  )
                : SvgPicture.asset(
                    AppAssets.filter,
                    height: 20,
                    width: 20,
                    fit: BoxFit.cover,
                  ),
          ],
        ),
      ),
    );
  }
}
