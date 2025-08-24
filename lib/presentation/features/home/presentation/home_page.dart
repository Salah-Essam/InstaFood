import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:insta_food/core/di/di.dart';
import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/core/utils/app_strings.dart';
import 'package:insta_food/presentation/features/home/widget/adSlider.dart';
import 'package:insta_food/presentation/features/home/widget/app_greeting.dart';
import 'package:insta_food/presentation/features/home/widget/bestseller_row.dart';
import 'package:insta_food/presentation/features/home/widget/home_buttonGrid.dart';
import 'package:insta_food/presentation/features/home/widget/recommend_tile.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';
import 'package:insta_food/presentation/features/items/presentation/cubit/item_cubit.dart';
import 'package:insta_food/presentation/widgets/custom_appbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  List<ItemModel> getRandomItems(List<ItemModel> allItems, {int count = 5}) {
    if (allItems.isEmpty) return [];
    final shuffled = List<ItemModel>.from(allItems)..shuffle();
    return shuffled.take(count).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ItemCubit>()..getallItems(),
      child: Scaffold(
        appBar: CustomAppBar(),
        body: BlocBuilder<ItemCubit, ItemState>(
          builder: (context, state) {
            if (state is ItemLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ItemFailure) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is ItemLoaded) {
              //Selects 5 random items for advertisment
              final featuredItems = getRandomItems(state.itemList, count: 5);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 35,
                    ),
                    child: Greetings(),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        color: AppColors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 36.0,
                          vertical: 31,
                        ),

                        child: Column(
                          children: [
                            ButtonGrid(),
                            SizedBox(height: 5),
                            Container(color: AppColors.orangeBase, height: 0.5),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    AppStrings.bestseller,
                                    style: AppTextStyles.header,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Row(
                                    children: [
                                      Text(
                                        AppStrings.viewAll,
                                        style: AppTextStyles.greetingDialoge,
                                      ),
                                      SvgPicture.asset(AppAssets.nextArrow),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            BestSellerRow(featuredItems: featuredItems),
                            SizedBox(height: 20),
                            AdSlider(featuredItems: featuredItems),
                            SizedBox(height: 21),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                AppStrings.recommend,
                                style: AppTextStyles.header,
                              ),
                            ),
                            Row(
                              spacing: 7,
                              children: [
                                RecommendTile(item: state.itemList[10]),
                                RecommendTile(item: state.itemList[4]),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return Center(
              child: ElevatedButton(
                onPressed: () => context.read<ItemCubit>().getallItems(),
                child: Text('Load Items'),
              ),
            );
          },
        ),
      ),
    );
  }
}
