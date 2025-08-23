import 'package:flutter/material.dart';
import 'package:insta_food/core/app_colors.dart';
import 'package:insta_food/core/app_textstyles.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';

class BestsellerTile extends StatelessWidget {
  final ItemModel item;
  const BestsellerTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 108,
      width: 71.7,
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
        ],
      ),
    );
  }
}
