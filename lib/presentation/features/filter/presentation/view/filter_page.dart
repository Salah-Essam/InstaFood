import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_food/core/di/di.dart';
import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/core/utils/app_strings.dart';
import 'package:insta_food/presentation/features/filter/presentation/cubit/filter_cubit.dart';
import 'package:insta_food/presentation/features/home/presentation/widget/home_button_grid.dart';
import 'package:insta_food/presentation/widgets/custom_appbar.dart';

class FilterPage extends StatelessWidget {
  const FilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FilterCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.primaryYellow,
        appBar: CustomAppBar(
          title: AppStrings.filter,
          leading: true,
          hideNotification: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: SizedBox(
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                child: BlocBuilder<FilterCubit, FilterState>(
                  builder: (context, state) {
                    if (state is SetFilter) {
                      state.printFilterParams();
                    }
                    return ListView(
                      children: [
                        Text(
                          AppStrings.categories,
                          style: AppTextStyles.header,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 26),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: AppColors.border,
                                  width: 0.5,
                                ),
                              ),
                            ),
                            child: ButtonGrid(),
                          ),
                        ),
                        Text(AppStrings.sortBy, style: AppTextStyles.header),
                        SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: AppColors.border,
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Row(
                              spacing: 10,
                              children: [
                                Text(
                                  AppStrings.topRated,
                                  style: AppTextStyles.mediumText,
                                ),
                                RatingStars(
                                  starOffColor: AppColors.primaryOrange,
                                  value: state is SetFilter
                                      ? (state.minRating ?? 0).toDouble()
                                      : 0.0,
                                  onValueChanged: (v) {
                                    context.read<FilterCubit>().setRatingFilter(
                                      v.toInt(),
                                    );
                                  },

                                  starBuilder: (index, color) {
                                    final currentRating = state is SetFilter
                                        ? state.minRating ?? 0
                                        : 0;
                                    final isFilled = index < currentRating;

                                    return SvgPicture.asset(
                                      isFilled
                                          ? AppAssets.ratingStar
                                          : AppAssets.ratingStarOutlined,
                                    );
                                  },
                                  starCount: 5,
                                  starSize: 20,
                                  starSpacing: 5,
                                  valueLabelVisibility: false,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Builder(
                          builder: (context) {
                            if (state is SetFilter) {
                              if (state.selectedCategory != null) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 13,
                                  ),
                                  child: Text(
                                    AppStrings.categories,
                                    style: AppTextStyles.mediumText,
                                  ),
                                );
                              }
                            }
                            return SizedBox.shrink();
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
