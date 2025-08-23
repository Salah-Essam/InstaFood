import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_food/core/app_assets.dart';
import 'package:insta_food/core/app_colors.dart';
import 'package:insta_food/core/app_strings.dart';
import 'package:insta_food/core/app_textstyles.dart';

class ButtonGrid extends StatelessWidget {
  const ButtonGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        itemCount: AppAssets.catagories.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 19, left: 1),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 49,
                  height: 62,

                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        AppColors.yellow2,
                      ),
                      padding: MaterialStateProperty.all(EdgeInsets.all(4)),
                    ),
                    child: SvgPicture.asset(
                      AppAssets.catagories[index],
                      height: 37,
                      width: 33,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(AppStrings.catagories[index], style: AppTextstyles.small),
              ],
            ),
          );
        },
      ),
    );
  }
}
