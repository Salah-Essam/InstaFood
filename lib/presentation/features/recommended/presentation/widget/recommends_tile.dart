import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/core/utils/app_alerts.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_state.dart';
import 'package:insta_food/presentation/features/bestSeller/data/model/best_seller_item_model.dart';
import 'package:insta_food/presentation/features/cart/data/models/cart_item_model.dart';
import 'package:insta_food/presentation/features/cart/logic/cart_cubit.dart';
import 'package:insta_food/presentation/features/cart/logic/cart_state.dart';
import 'package:insta_food/presentation/features/filter/data/enum/catagories_enum.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';
import 'package:insta_food/presentation/features/items/data/model/item_size.dart';
import 'package:insta_food/presentation/features/items/presentation/view/item_page.dart';
import 'package:insta_food/presentation/features/items/presentation/widgets/app_counter.dart';
import 'package:insta_food/presentation/features/items/presentation/widgets/fav_button.dart';
import 'package:insta_food/presentation/widgets/cached_image.dart';
import 'package:insta_food/presentation/widgets/rating_container.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class RecommendsTile extends StatefulWidget {
  final BestSellerItem item;
  const RecommendsTile({super.key, required this.item});

  @override
  State<RecommendsTile> createState() => _RecommendsTileState();
}

class _RecommendsTileState extends State<RecommendsTile> {
  @override
  Widget build(BuildContext context) {
    ValueNotifier<int> _qty = ValueNotifier<int>(1);

    return SizedBox(
      width: 158,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                        screen: ItemPage(item: widget.item),
                        withNavBar: true,
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedImage(item: widget.item),
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
                          widget.item.category != null
                              ? FoodCategory.fromString(
                                  widget.item.category!,
                                ).icon
                              : FoodCategory.snacks.icon,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: RatingContainer(padding: EdgeInsets.all(8)),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              widget.item.itemName,
              style: AppTextStyles.fontBlackMed,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              widget.item.itemDescription ?? "",
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ValueListenableBuilder<int>(
                  valueListenable: _qty,
                  builder: (_, qty, __) {
                    final price = widget.item.itemPrice * qty;
                    return Text(
                      "\$${price.toStringAsFixed(1)}",
                      style: AppTextStyles.fontPrimaryMediumRagular,
                    );
                  },
                ),
                SizedBox(
                  width: 57,
                  height: 19,
                  child: FittedBox(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Counter(
                          initNumber: _qty.value,
                          counterCallback: (v) => _qty.value = v,
                        );
                      },
                    ),
                  ),
                ),
                InkWell(
                  child: SvgPicture.asset(AppAssets.cartOrange),
                  onTap: () {
                    final cartitem = CartItemModel.fromItem(
                      item: widget.item,
                      size: ItemSize.medium,
                      quantity: _qty.value,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
