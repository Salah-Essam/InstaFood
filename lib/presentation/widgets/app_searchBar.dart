import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/core/utils/app_strings.dart';

class searchBar extends StatefulWidget {
  const searchBar({super.key, required this.enabled, this.onPressed});
  final bool enabled;
  final VoidCallback? onPressed;
  @override
  State<searchBar> createState() => _searchBarState();
}

class _searchBarState extends State<searchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 26,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        color: AppColors.white,
      ),
      child: Center(
        child: TextFormField(
          enabled: widget.enabled,
          decoration: InputDecoration(
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.only(
              top: 8,
              bottom: 8,
              left: 16,
              right: 2,
            ),
            hint: Text(AppStrings.search, style: AppTextStyles.search),
            suffixIcon: IconButton(
              icon: SvgPicture.asset(
                AppAssets.filter,
                height: 20,
                width: 20,
                fit: BoxFit.fitWidth,
                clipBehavior: Clip.none,
              ),
              onPressed: widget.onPressed ?? () {},
            ),
          ),
        ),
      ),
    );
  }
}
