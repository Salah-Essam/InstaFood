import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insta_food/core/di/di.dart';
import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/core/utils/app_strings.dart';
import 'package:insta_food/presentation/features/bestSeller/presentation/cubit/best_sellers_cubit.dart';
import 'package:insta_food/presentation/features/bestSeller/presentation/view/best_seller_page.dart';
import 'package:insta_food/presentation/features/filter/presentation/cubit/filter_cubit.dart';
import 'package:insta_food/presentation/features/home/presentation/widget/ad_slider.dart';
import 'package:insta_food/presentation/features/home/presentation/widget/app_greeting.dart';
import 'package:insta_food/presentation/features/home/presentation/widget/bestseller_row.dart';
import 'package:insta_food/presentation/widgets/button_grid.dart';
import 'package:insta_food/presentation/features/home/presentation/widget/item_tile.dart';
import 'package:insta_food/presentation/features/items/presentation/cubit/item_cubit.dart';
import 'package:insta_food/presentation/widgets/custom_appbar.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<ItemCubit>()..getallItems()),
        BlocProvider(create: (context) => sl<FilterCubit>()),
        BlocProvider(
          create: (context) => sl<BestSellersCubit>()..getBestSellers(),
        ),
      ],

      child: Scaffold(
        backgroundColor: AppColors.primaryYellow,
        appBar: CustomAppBar(),
        body: BlocBuilder<ItemCubit, ItemState>(
          builder: (context, state) {
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
                    child: Builder(
                      builder: (context) {
                        if (state is ItemLoading) {
                          return Center(child: CircularProgressIndicator());
                        } else if (state is ItemFailure) {
                          return Center(child: Text('Error: ${state.message}'));
                        } else if (state is ItemLoaded) {
                          return ListView(
                            // Keep a small bottom padding so content doesn't hide under the bottom nav,
                            // but avoid excessive blank space on shorter screens.
                            padding: EdgeInsets.fromLTRB(
                              36,
                              31,
                              36,
                              MediaQuery.of(context).padding.bottom,
                            ),
                            children: [
                              ButtonGrid(isselected: false),
                              SizedBox(height: 5),
                              Container(
                                color: AppColors.primaryOrange,
                                height: 0.5,
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      AppStrings.bestseller,
                                      style: AppTextStyles.header,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      pushScreen(
                                        context,
                                        screen: BestSellerPage(),
                                        withNavBar: true,
                                      );
                                    },
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
                              BlocBuilder<BestSellersCubit, BestSellersState>(
                                builder: (context, state) {
                                  if (state is BestSellersLoaded) {
                                    return BestSellerRow(
                                      featuredItems: state.featuredBestSellers,
                                    );
                                  }
                                  return SizedBox.shrink();
                                },
                              ),
                              SizedBox(height: 20),
                              AdSlider(featuredItems: state.featuredItems!),
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
                                  final double tileWidth =
                                      (constraints.maxWidth - gap) / 2;
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                          );
                        }
                        return SizedBox();
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
