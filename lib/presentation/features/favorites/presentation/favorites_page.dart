import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/core/utils/app_strings.dart';
import 'package:insta_food/presentation/features/favorites/logic/favorites_cubit.dart';
import 'package:insta_food/presentation/features/items/presentation/widgets/fav_button.dart';
import 'package:insta_food/presentation/widgets/cached_image.dart';
import 'package:insta_food/presentation/widgets/shared_scaffold.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      appBarTitle: 'Favorites',
      pageDetails: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          final items = state.items;
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(AppAssets.fav, width: 64, height: 64),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.favoritesHeadline,
                    style: AppTextStyles.header.copyWith(color: AppColors.primaryOrange),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              // Simple responsive 2-column grid
              final crossAxisCount = 2;
              final spacing = 16.0;
              final tileWidth = (constraints.maxWidth - spacing) / crossAxisCount;
              const imageHeight = 140.0;

              return GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  // Enough vertical space for image + texts
                  childAspectRatio: tileWidth / (imageHeight + 80),
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: SizedBox(
                              height: imageHeight,
                              width: double.infinity,
                              child: CachedImage(item: item),
                            ),
                          ),
                          Positioned(
                            left: 10,
                            top: 10,
                            child: Image.asset(
                              AppAssets.smallMeals,
                              width: 26,
                              height: 26,
                            ),
                          ),
                          Positioned(
                            right: 10,
                            top: 10,
                            child: FavButton(
                              width: 26,
                              height: 26,
                              item: item,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          item.itemName,
                          style: AppTextStyles.header.copyWith(color: AppColors.primaryOrange),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      if (item.itemDescription != null) ...[
                        const SizedBox(height: 4),
                        Center(
                          child: Text(
                            item.itemDescription!,
                            style: AppTextStyles.small.copyWith(color: AppColors.textSecondary),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
