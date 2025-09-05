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
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    decoration: BoxDecoration(
                      border: isSelected
                          ? Border.all(color: AppColors.white, width: 6.0)
                          : null,
                      // Use simple rounded top corners for unselected state.
                      borderRadius: isSelected
                          ? null
                          : BorderRadius.only(
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
    final Path p = Path();

    // Tunable constants (relative to size) to match the Figma selected-category halo.
    // The idea: a rounded top, then fully smooth concave curves on both sides flowing into the bottom.
    final double rTop = 24; // top corner radius (px-like)
    final double topInset = 0; // tiny inset to avoid hairlines with background

    // Make bottom corners match the top radius exactly (inverted).
    final double anchorY = size.height - rTop;

    // Small smoothing for vertical transitions.
    const double vLift = 10; // vertical lift before anchor for softness
    const double vMid = 14; // vertical continuity from top arc
    final double rt = rTop.clamp(0, size.width / 2).toDouble();

    final double w = size.width;
    final double h = size.height;

    // --- Top cap (soft rectangle top) ---
    p.moveTo(rt, topInset);
    p.lineTo(size.width - rt, topInset);
    p.quadraticBezierTo(size.width, topInset, size.width, rt);

    // --- Right side: smooth descent then exact inverted rounded corner ---
    p.cubicTo(w, rt + vMid, w, anchorY - vLift, w, anchorY);
    // Quarter-circle inward to the bottom with the same radius as the top.
    p.arcToPoint(
      Offset(w - rt, h),
      radius: Radius.circular(rt),
      clockwise: true,
    );

    // --- Bottom run ---
    p.lineTo(rt, h);

    // --- Left side: mirror of right ---
    p.arcToPoint(
      Offset(0, anchorY),
      radius: Radius.circular(rt),
      clockwise: true,
    );
    // Smooth ascent into the top-left rounded corner.
    p.cubicTo(0, anchorY - vLift, 0, rt + vMid, 0, rt);

    // Top-left corner back to start.
    p.quadraticBezierTo(0, topInset, rt, topInset);

    p.close();
    return p;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
