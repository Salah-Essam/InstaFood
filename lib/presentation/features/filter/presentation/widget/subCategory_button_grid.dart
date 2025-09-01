import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/presentation/features/filter/data/enum/catagories_enum.dart';
import 'package:insta_food/presentation/features/filter/presentation/cubit/filter_cubit.dart';
import 'package:insta_food/presentation/widgets/app_button_onb.dart';

class SubcategoryButtonGrid extends StatelessWidget {
  final FoodCategory category;
  const SubcategoryButtonGrid({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterCubit, FilterState>(
      builder: (context, state) {
        return SizedBox(
          height: 100,
          width: double.infinity,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 11,
              mainAxisSpacing: 8,
              childAspectRatio: 100 / 24,
            ),
            itemCount: category.keywords.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 12),

            itemBuilder: (context, index) {
              // Get the category key and asset path by index
              final subCategory = category.keywords[index];

              final isSelected =
                  state is SetFilter && state.subCategory == subCategory;
              return Padding(
                padding: const EdgeInsets.only(right: 19, left: 1),
                child: AppButton(
                  onPressed: () {
                    context.read<FilterCubit>().toggleSubCategory(subCategory);
                  },
                  backgroundColor: isSelected
                      ? AppColors.primaryOrange
                      : AppColors.lightOrange,
                  borderRadius: 30,
                  width: 100,
                  height: 24,
                  child: Padding(
                    padding: const EdgeInsets.all(0.1),
                    child: Text(
                      subCategory,
                      style: isSelected
                          ? AppTextStyles.subCatagoryButton.copyWith(
                              color: AppColors.white,
                            )
                          : AppTextStyles.subCatagoryButton,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
