import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_food/core/di/di.dart';
import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/utils/app_strings.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/presentation/features/filter/data/enum/catagories_enum.dart';
import 'package:insta_food/presentation/features/filter/presentation/cubit/filter_cubit.dart';
import 'package:insta_food/presentation/widgets/app_button_onb.dart';

class CatagoryButtonGrid extends StatelessWidget {
  CatagoryButtonGrid({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterCubit, FilterState>(
      builder: (context, state) {
        return SizedBox(
          height: 100,
          child: ListView.builder(
            itemCount: FoodCategory.values.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),

            itemBuilder: (context, index) {
              // Get the category key and asset path by index
              final category = FoodCategory.values[index];

              final isSelected =
                  state is SetFilter && state.selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.only(right: 19, left: 1),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppButton(
                      onPressed: () {
                        context.read<FilterCubit>().toggleCategory(category);
                      },
                      backgroundColor: isSelected
                          ? AppColors.primaryYellow
                          : AppColors.lightYellow,
                      borderRadius: 30,
                      width: 49,
                      height: 62,
                      child: SizedBox(
                        height: 37,
                        width: 33,
                        child: Transform.scale(
                          scale: 1,
                          child: SvgPicture.asset(
                            category.icon,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(category.name, style: AppTextStyles.small),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
