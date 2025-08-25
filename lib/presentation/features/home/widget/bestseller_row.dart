import 'package:flutter/material.dart';
import 'package:insta_food/presentation/features/home/widget/item_tile.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';

class BestSellerRow extends StatelessWidget {
  const BestSellerRow({super.key, required this.featuredItems});

  final List<ItemModel> featuredItems;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 112,
      child: ListView.builder(
        itemCount: featuredItems.length - 1,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(left: 8, right: 8),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ItemTile(
              height: 108,
              width: 88,
              item: featuredItems[index],
            ),
          );
        },
      ),
    );
  }
}
