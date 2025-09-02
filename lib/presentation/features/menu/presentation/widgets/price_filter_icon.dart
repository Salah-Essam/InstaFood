import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/presentation/features/menu/presentation/cubit/menu_cubit.dart';
import 'package:insta_food/presentation/features/menu/presentation/cubit/menu_cubit_state.dart';
import 'package:insta_food/core/constants/menu_constants.dart';

// Popup menu filter icon (icon only, no background). Appears over UI without reserving space.
class PriceFilterIcon extends StatelessWidget {
  const PriceFilterIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuCubit, MenuState>(
      builder: (context, state) {
        if (state is! MenuLoaded) return const SizedBox.shrink();
        final active = state.activePriceFilter;
        return PopupMenuButton<String>(
          tooltip: 'Sort by price',
          onSelected: (value) {
            context.read<MenuCubit>().filterByPrice(value);
          },
          itemBuilder: (ctx) => [
            for (final option in MenuConstants.priceFilterOptions)
              PopupMenuItem<String>(
                value: option,
                child: Row(
                  children: [
                    if (option == active)
                      const Icon(Icons.check, size: 16, color: AppColors.primaryOrange)
                    else
                      const SizedBox(width: 16),
                    const SizedBox(width: 4),
                    Text(option),
                  ],
                ),
              ),
          ],
          child: SvgPicture.asset(
            AppAssets.filter,
            width: 24,
            height: 24,
            ),
        );
      },
    );
  }
}
