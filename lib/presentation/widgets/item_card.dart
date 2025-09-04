import 'package:flutter/material.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';
import 'package:insta_food/presentation/features/items/presentation/view/item_page.dart';
import 'package:insta_food/presentation/widgets/cached_image.dart';
import 'package:insta_food/presentation/widgets/rating_container.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class ItemCard extends StatelessWidget {
  final ItemModel item;
  const ItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 26),
      child: InkWell(
        onTap: () {
          pushScreen(context, screen: ItemPage(item: item), withNavBar: true);
        },
        child: Center(
          child: SizedBox(
            width: 323,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.border, width: 0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(36),
                    child: CachedImage(width: 323, height: 174, item: item),
                  ),


                  SizedBox(
                    width: 323,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      spacing: 8,
                      children: [
                        Text(item.itemName, style: AppTextStyles.header),
                        CircleAvatar(
                          radius: 2.5,
                          backgroundColor: AppColors.primaryOrange,
                        ),
                        RatingContainer(padding: EdgeInsets.all(1)),


                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "\$${item.itemPrice.toStringAsFixed(1)}",
                              style: AppTextStyles.fontPrimaryMediumRagular,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Text(item.itemDescription ?? "", style: AppTextStyles.small),
                  SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
