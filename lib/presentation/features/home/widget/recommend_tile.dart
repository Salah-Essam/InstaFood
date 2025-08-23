import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insta_food/core/app_assets.dart';
import 'package:insta_food/core/app_colors.dart';
import 'package:insta_food/core/app_textstyles.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';

class RecommendTile extends StatelessWidget {
  final ItemModel item;
  const RecommendTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: 159,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(item.imageUrl, fit: BoxFit.cover),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 12,
            child: Container(
              width: 38,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
                color: AppColors.orangeBase,
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "\$${item.itemPrice..toStringAsFixed(1)}",
                  style: AppTextstyles.price,
                ),
              ),
            ),
          ),
          Positioned(
            left: 13,
            top: 10,
            child: SvgPicture.asset(AppAssets.rating),
          ),
          Positioned(left: 52, top: 10, child: SvgPicture.asset(AppAssets.fav)),
        ],
      ),
    );
  }
}
