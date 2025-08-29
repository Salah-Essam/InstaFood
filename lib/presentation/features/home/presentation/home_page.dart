import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:insta_food/core/di/di.dart';
import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_strings.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/presentation/features/home/widget/ad_slider.dart';
import 'package:insta_food/presentation/features/home/widget/app_greeting.dart';
import 'package:insta_food/presentation/features/home/widget/bestseller_row.dart';
import 'package:insta_food/presentation/features/home/widget/home_button_grid.dart';
import 'package:insta_food/presentation/features/home/widget/item_tile.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';
import 'package:insta_food/presentation/features/items/presentation/cubit/item_cubit.dart';
import 'package:insta_food/presentation/widgets/custom_appbar.dart';
import 'package:insta_food/presentation/features/drawer/presentation/cubit/drawer_cubit.dart';
import 'package:insta_food/presentation/features/drawer/presentation/view/app_drawer.dart';

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
      child: BlocListener<DrawerCubit, DrawerState>(
        listener: (context, state) {
          if (state is DrawerOpened) {
            Scaffold.of(context).openEndDrawer();
          }
        },
        child: BlocBuilder<DrawerCubit, DrawerState>(
          builder: (context, drawerState) {
            return Scaffold(
              backgroundColor: AppColors.statusBar,
              appBar: CustomAppBar(),
              endDrawer: drawerState is DrawerOpened 
                  ? AppDrawer(drawerSelected: drawerState.type) 
                  : null,
              onEndDrawerChanged: (isOpen) {
                if (!isOpen) {
                  context.read<DrawerCubit>().closeDrawer();
                }
              },
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
                      child: ListView(
                        // Keep a small bottom padding so content doesn't hide under the bottom nav,
                        // but avoid excessive blank space on shorter screens.
                        padding: EdgeInsets.fromLTRB(
                          36,
                          31,
                          36,
                          20 + MediaQuery.of(context).padding.bottom + 16,
                        ),
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
                                      style: AppTextStyles.greetingDialog,
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
                          LayoutBuilder(
                            builder: (context, constraints) {
                              const gap = 7.0;
                              final double tileWidth = (constraints.maxWidth - gap) / 2;
                              return Row(
                                children: [
                                  ItemTile(
                                    height: 140,
                                    width: tileWidth,
                                    showButtons: true,
                                    item: state.itemList[10],
                                  ),
                                  const SizedBox(width: gap),
                                  ItemTile(
                                    height: 140,
                                    width: tileWidth,
                                    showButtons: true,
                                    item: state.itemList[4],
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                        ],
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
        );
      },
      ),
      ),
    );
  }
}
