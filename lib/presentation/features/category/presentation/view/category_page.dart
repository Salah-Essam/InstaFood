import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_food/core/di/di.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/presentation/features/filter/presentation/cubit/filter_cubit.dart';
import 'package:insta_food/presentation/features/home/presentation/widget/home_button_grid.dart';
import 'package:insta_food/presentation/features/home/presentation/widget/item_tile.dart';
import 'package:insta_food/presentation/features/items/presentation/cubit/item_cubit.dart';
import 'package:insta_food/presentation/widgets/custom_appbar.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<ItemCubit>()..getallItems()),
        BlocProvider.value(value: sl<FilterCubit>()),
      ],
      child: BlocListener<FilterCubit, FilterState>(
        listener: (context, state) {
          // Refresh items whenever filters change
          if (context.read<FilterCubit>().state is ApplyFilter) {
            context.read<ItemCubit>().getallItems();
          } else if (context.read<FilterCubit>().state is SetFilter) {
            // Optional: refresh for preview, or wait for apply
            context.read<ItemCubit>().getallItems();
          }
        },
        child: BlocBuilder<FilterCubit, FilterState>(
          builder: (context, state) {
            return PopScope(
              onPopInvokedWithResult: (didPop, result) {
                if (didPop) {
                  // Reset category filter when popping
                  context.read<FilterCubit>().setCategoryFilter(null);
                  context.read<FilterCubit>().resetFilter();
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
                                Builder(
                                  builder: (context) {
                                    if (state is ItemLoading) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (state is ItemFailure) {
                                      return Center(
                                        child: Text('Error: ${state.message}'),
                                      );
                                    } else if (state is ItemLoaded) {
                                      debugPrint(
                                        "${state.activeFilters} : ${state.searchedItems}",
                                      );
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        physics: ScrollPhysics(),
                                        itemCount: state.searchedItems.length,
                                        itemBuilder: (context, index) {
                                          final item =
                                              state.searchedItems[index];
                                          return ItemTile(
                                            item: item,
                                            height: 108,
                                            width: 88,
                                          );
                                        },
                                      );
                                    } else {
                                      return SizedBox.shrink();
                                    }
                                  },
                                ),
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
      ),
    );
  }
}
