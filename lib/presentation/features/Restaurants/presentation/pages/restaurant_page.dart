import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/presentation/features/Restaurants/presentation/cubit/restaurants_cubit.dart';
import 'package:insta_food/presentation/features/Restaurants/presentation/cubit/restaurants_cubit_state.dart';
import 'package:insta_food/presentation/features/Restaurants/presentation/widgets/restaurant_card.dart';
import 'package:insta_food/presentation/features/Restaurants/presentation/widgets/restaurant_filters.dart';
import 'package:insta_food/presentation/widgets/app_backbutton.dart';

class RestaurantListPage extends StatelessWidget {
  const RestaurantListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryYellow,
      body: Column(
        children: [
          SizedBox(
            height: 140,
            child: Padding(
              padding: const EdgeInsets.only(top: 48, left: 8, right: 16),
              child: SizedBox(
              height: 40,
              child: Stack(
                alignment: Alignment.center,
                children: [
                Center(
                  child: Text(
                  'Restaurants',
                  style: AppTextStyles.fontWhiteLargeBold,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    AppBackButton(),
                    SizedBox(width: 8),
                  ],
                  ),
                ),
                ],
              ),
              ),
            ),
            ),
          Expanded(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: BlocBuilder<RestaurantsCubit, RestaurantsState>(
                    buildWhen: (p, c) => true,
                    builder: (context, state) {
                      RestaurantsState effective = state;
                      String? toast;
                      if (state is RestaurantsToast) {
                        toast = state.message;
                        effective = state.previous;
                      }
                      Widget content;
                      if (effective is RestaurantsLoading) {
                        content = const Center(child: CircularProgressIndicator());
                      } else if (effective is RestaurantsError) {
                        content = Center(child: Text(effective.message, style: AppTextStyles.body.copyWith(color: AppColors.error)));
                      } else if (effective is RestaurantsLoaded) {
                        final list = effective.restaurants;
                        content = list.isEmpty
                            ? Center(child: Text('No restaurants found', style: AppTextStyles.body))
                            : ListView.separated(
                                padding: const EdgeInsets.fromLTRB(0, 4, 0, 16),
                                itemCount: list.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 12),
                                itemBuilder: (ctx, i) => RestaurantCard(restaurant: list[i]),
                              );
                      } else {
                        content = const SizedBox.shrink();
                      }
                      return Column(
                        children: [
                          if (toast != null)
                            Container(
                              width: double.infinity,
                              color: toast.contains('back') ? Colors.green : Colors.red,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              child: Text(toast, style: AppTextStyles.small.copyWith(color: Colors.white)),
                            ),
                          RestaurantFilters(onFilterChanged: (filterType, value) {
                            context.read<RestaurantsCubit>().applyFilter(filterType: filterType, query: value);
                          }),
                          Expanded(child: content),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}