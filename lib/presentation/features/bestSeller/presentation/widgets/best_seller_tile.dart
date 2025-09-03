import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/core/utils/app_alerts.dart';
import 'package:insta_food/core/utils/app_strings.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_state.dart';
import 'package:insta_food/presentation/features/bestSeller/data/model/best_seller_item_model.dart';
import 'package:insta_food/presentation/features/cart/data/models/cart_item_model.dart';
import 'package:insta_food/presentation/features/cart/logic/cart_cubit.dart';
import 'package:insta_food/presentation/features/cart/logic/cart_state.dart';
import 'package:insta_food/presentation/features/filter/data/enum/catagories_enum.dart';
import 'package:insta_food/presentation/features/items/data/model/item_size.dart';
import 'package:insta_food/presentation/features/items/presentation/view/item_page.dart'
    show ItemPage;
import 'package:insta_food/presentation/features/items/presentation/widgets/fav_button.dart';
import 'package:insta_food/presentation/widgets/cached_image.dart';
import 'package:insta_food/presentation/widgets/rating_container.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class BestSellerTile extends StatelessWidget {
  final BestSellerItem item;
  const BestSellerTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 158,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 158,
            height: 141,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Stack(
              children: [
                Positioned.fill(
                  child: InkWell(
                    onTap: () {
                      pushScreen(
                        context,
                        screen: ItemPage(item: item),
                        withNavBar: true,
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedImage(item: item),
                    ),
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
                      color: AppColors.primaryOrange,
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(1),
                        child: SvgPicture.asset(
                          FoodCategory.fromString(item.category!).icon,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: FavButton(item: item),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  item.itemName,
                  style: AppTextStyles.fontBlackMed,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              RatingContainer(padding: EdgeInsets.all(0)),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  item.itemDescription ?? "",
                  style: AppTextStyles.small,

                  overflow: TextOverflow.ellipsis,
                ),
              ),
              BlocListener<CartCubit, CartState>(
                listenWhen: (p, n) => n is CartActionBlocked,
                listener: (context, state) {
                  if (state is CartActionBlocked &&
                      state.reason == 'login_required') {
                    AppAlerts.showLoginRequiredDialog(context);
                  }
                },
                child: InkWell(
                  child: SvgPicture.asset(AppAssets.cartOrange),
                  onTap: () {
                    final cartitem = CartItemModel.fromItem(
                      item: item,
                      size: ItemSize.medium,
                      quantity: 1,
                    );
                    final isAuthed =
                        context.read<AuthCubit>().state is! Unauthenticated;
                    context.read<CartCubit>().addOrUpdate(cartitem).then((_) {
                      if (!context.mounted) return;
                      if (isAuthed) {
                        AppAlerts.showSuccessDialog(
                          context,
                          title: 'Added to cart successfully!',
                          imageAsset: 'assets/images/greencheckmark.jpg',
                        );
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
