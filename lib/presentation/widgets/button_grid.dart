import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/presentation/features/category/presentation/view/category_page.dart';
import 'package:insta_food/presentation/features/filter/data/enum/catagories_enum.dart';
import 'package:insta_food/presentation/features/filter/presentation/cubit/filter_cubit.dart';
import 'package:insta_food/presentation/widgets/app_button_onb.dart';

class ButtonGrid extends StatelessWidget {
  final bool? pushPage;
  final bool? isselected;
  const ButtonGrid({super.key, this.pushPage = true, this.isselected});
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
                  isselected ??
                  (state is SetCatagoryFilter &&
                          state.selectedCategory == category) ||
                      (state is ApplyFilter &&
                          state.selectedCategory == category);
              return Padding(
                padding: const EdgeInsets.only(right: 19, left: 1),
                child: ClipPath(
                  clipper: isSelected ? MyCustomClipper() : null,
                  child: Container(
                    decoration: BoxDecoration(
                      border: isSelected
                          ? Border.all(color: AppColors.white, width: 6.0)
                          : null,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      color: isSelected ? AppColors.white : null,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppButton(
                          onPressed: pushPage!
                              ? () {
                                  context.read<FilterCubit>()
                                    ..setCategoryFilter(category)
                                    ..applyFilters();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CategoryPage(),
                                    ),
                                  );
                                }
                              : () {
                                  context.read<FilterCubit>()
                                    ..setCategoryFilter(category)
                                    ..applyFilters();
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

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    const double cornerRadius = 0.2; // Control the curve's intensity

    // Start from the top-left curve point
    path.moveTo(size.width * cornerRadius, 0);

    // Draw the top line
    path.lineTo(size.width * (1 - cornerRadius), 0);
    // Draw top-right curve
    path.quadraticBezierTo(
      size.width,
      0,
      size.width,
      size.height * cornerRadius,
    );

    // Draw the right side line
    path.lineTo(size.width, size.height * (1 - cornerRadius));
    // Draw the bottom-right curve
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width * (1 - cornerRadius),
      size.height,
    );

    // Draw the wider bottom line
    path.lineTo(size.width * cornerRadius, size.height);

    // Draw the bottom-left curve
    path.quadraticBezierTo(0, size.height, 0, size.height * (1 - cornerRadius));

    // Draw the left side line
    path.lineTo(0, size.height * cornerRadius);
    // Draw the top-left curve
    path.quadraticBezierTo(0, 0, size.width * cornerRadius, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
