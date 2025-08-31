import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_food/core/di/di.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/presentation/features/home/presentation/widget/item_tile.dart';
import 'package:insta_food/presentation/features/items/presentation/cubit/item_cubit.dart';
import 'package:insta_food/presentation/widgets/custom_appbar.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ItemCubit>()..searchItem(""),
      child: Scaffold(
        backgroundColor: AppColors.primaryYellow,
        appBar: CustomAppBar(inableSearch: true, leading: true),
        body: BlocBuilder<ItemCubit, ItemState>(
          builder: (context, state) {
            return SizedBox(
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
                  child: Builder(
                    builder: (context) {
                      if (state is ItemLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is ItemFailure) {
                        return Center(child: Text('Error: ${state.message}'));
                      } else if (state is ItemLoaded) {
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                childAspectRatio: 88 / 108,
                              ),
                          itemCount: state.searchedItems.length,
                          itemBuilder: (context, index) {
                            final item = state.searchedItems[index];
                            return ItemTile(item: item, height: 108, width: 88);
                          },
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
