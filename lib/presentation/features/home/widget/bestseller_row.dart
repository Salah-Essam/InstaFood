import 'package:flutter/material.dart';
import 'package:insta_food/presentation/features/home/widget/item_tile.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';

class BestSellerRow extends StatelessWidget {
  const BestSellerRow({super.key, required this.featuredItems});

  final List<ItemModel> featuredItems;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 108,
        child: ListView.builder(
          itemCount: featuredItems.length - 1,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 10, left: 1),
              child: ItemTile(
                height: 108,
                width: 71.7,
                item: featuredItems[index],
              ),
            );
          },
        ),
      ),
    );
  }
}
