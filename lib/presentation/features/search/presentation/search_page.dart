import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_food/core/di/di.dart';
import 'package:insta_food/core/network/network_info.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/core/utils/app_strings.dart';
import 'package:insta_food/presentation/features/filter/presentation/cubit/filter_cubit.dart';
import 'package:insta_food/presentation/features/home/presentation/widget/item_tile.dart';
import 'package:insta_food/presentation/features/items/presentation/cubit/item_cubit.dart';
import 'package:insta_food/presentation/widgets/custom_appbar.dart';
import 'package:insta_food/presentation/widgets/item_card.dart';
import 'package:insta_food/presentation/widgets/sort_row.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<ItemCubit>()..getallItems()),
        BlocProvider.value(value: sl<FilterCubit>()..resetCategoryFilter()),
      ],
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
                  child: FutureBuilder(
                    future: sl<NetworkInfo>().isConnected,
                    builder: (context, snapshot) {
                      if (snapshot.hasError || snapshot.data == false) {
                        return Center(
                          child: Text(
                            AppStrings.disconnect,
                            style: AppTextStyles.header,
                            textAlign: TextAlign.center,
                          ),
                        );
                      } else {
                        return Builder(
                          builder: (context) {
                            if (state is ItemLoading) {
                              return Center(child: CircularProgressIndicator());
                            } else if (state is ItemFailure) {
                              return Center(
                                child: Text('Error: ${state.message}'),
                              );
                            } else if (state is ItemLoaded) {
                              return ListView(
                                children: [
                                  SortRow(),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    physics: ScrollPhysics(),
                                    itemCount: state.searchedItems.length,
                                    itemBuilder: (context, index) {
                                      final item = state.searchedItems[index];
                                      return ItemCard(item: item);
                                    },
                                  ),
                                ],
                              );
                            } else {
                              return SizedBox.shrink();
                            }
                          },
                        );
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
