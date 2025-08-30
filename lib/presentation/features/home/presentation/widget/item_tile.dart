import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';
import 'package:insta_food/presentation/features/items/presentation/view/item_page.dart';
import 'package:insta_food/presentation/widgets/cached_image.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class ItemTile extends StatelessWidget {
  final ItemModel item;
  final double height;
  final double width;
  final bool showButtons;
  const ItemTile({
    super.key,
    required this.item,
    required this.height,
    required this.width,
    this.showButtons = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        pushScreen(context, screen: ItemPage(item: item), withNavBar: true);
      },
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedImage(item: item),
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
                  color: AppColors.primary,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "\$${item.itemPrice.toStringAsFixed(1)}",
                    style: AppTextStyles.price,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 13,
              top: 10,
              child: Visibility(
                visible: showButtons,
                child: SvgPicture.asset(AppAssets.rating),
              ),
            ),
            Positioned(
              left: 52,
              top: 10,
              child: Visibility(
                visible: showButtons,
                child: SvgPicture.asset(AppAssets.fav),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
