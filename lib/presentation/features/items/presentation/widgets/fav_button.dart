import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/presentation/features/favorites/logic/favorites_cubit.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';

class FavButton extends StatelessWidget {
  final double? height;
  final double? width;
  final ItemModel? item;
  const FavButton({super.key, this.width, this.height, this.item});

  @override
  Widget build(BuildContext context) {
    final itemModel = item;
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        final isFav = itemModel != null
            ? context.read<FavoritesCubit>().isFavorite(itemModel.itemID)
            : false;
        final iconAsset = isFav ? AppAssets.favOrange : AppAssets.fav;
        return InkWell(
          onTap: itemModel == null
              ? null
              : () => context.read<FavoritesCubit>().toggle(itemModel),
          child: SvgPicture.asset(
            iconAsset,
            fit: BoxFit.cover,
            width: width ?? 21,
            height: height ?? 21,
          ),
        );
      },
    );
  }
}
