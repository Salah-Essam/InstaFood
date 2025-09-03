import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_food/core/di/di.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/core/utils/app_strings.dart';
import 'package:insta_food/presentation/features/bestSeller/presentation/cubit/best_sellers_cubit.dart';
import 'package:insta_food/presentation/features/bestSeller/presentation/widgets/best_seller_tile.dart';
import 'package:insta_food/presentation/features/home/presentation/widget/item_tile.dart';
import 'package:insta_food/presentation/widgets/app_backbutton.dart';
import 'package:insta_food/presentation/widgets/shared_scaffold.dart';

class BestSellerPage extends StatelessWidget {
  const BestSellerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BestSellersCubit>()..getBestSellers(),
      child: SharedScaffold(
        appBarTitle: AppStrings.bestseller,
        leading: AppBackButton(onTap: () => Navigator.pop(context)),
        pageDetails: BlocBuilder<BestSellersCubit, BestSellersState>(
          builder: (context, state) {
            if (state is BestSellersloading) {
              Center(child: CircularProgressIndicator());
            } else if (state is BestSellersError) {
              Center(child: Text('Error: ${state.message}'));
            } else if (state is BestSellersLoaded) {
              return ListView(
                children: [
                  Center(
                    child: Text(
                      AppStrings.bestSellerDialoge,
                      style: AppTextStyles.fontPrimaryHeaderRagular,
                    ),
                  ),
                  SizedBox(height: 24),
                  Center(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                      ),
                      itemCount: state.bestSellers.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      itemBuilder: (context, index) {
                        return BestSellerTile(item: state.bestSellers[index]);
                      },
                    ),
                  ),
                ],
              );
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
