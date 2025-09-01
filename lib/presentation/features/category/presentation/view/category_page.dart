import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_food/core/di/di.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/presentation/features/filter/presentation/cubit/filter_cubit.dart';
import 'package:insta_food/presentation/features/home/presentation/widget/home_button_grid.dart';
import 'package:insta_food/presentation/features/items/presentation/cubit/item_cubit.dart';
import 'package:insta_food/presentation/widgets/custom_appbar.dart';
import 'package:insta_food/presentation/widgets/shared_scaffold.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<ItemCubit>()),
        BlocProvider.value(value: sl<FilterCubit>()),
      ],
      child: BlocBuilder<FilterCubit, FilterState>(
        builder: (context, state) {
          String categoryText = 'No category selected';
          if (state is SetCatagoryFilter && state.selectedCategory != null) {
            categoryText = 'Selected Category: ${state.selectedCategory!.name}';
          }
          return PopScope(
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) {
                // Reset category filter when popping
                context.read<FilterCubit>().setCategoryFilter(null);
              }
            },
            child: Scaffold(
              backgroundColor: AppColors.primaryYellow,
              appBar: CustomAppBar(leading: true),
              body: BlocBuilder<ItemCubit, ItemState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                            color: AppColors.white,
                          ),
                          child: ListView(
                            padding: EdgeInsets.fromLTRB(
                              36,
                              31,
                              36,
                              MediaQuery.of(context).padding.bottom,
                            ),
                            children: [
                              ButtonGrid(pushPage: false),
                              Text(categoryText),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
