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
import 'package:insta_food/presentation/features/items/presentation/view/item_page.dart';
import 'package:insta_food/presentation/features/items/presentation/widgets/app_counter.dart';
import 'package:insta_food/presentation/widgets/cached_image.dart';
import 'package:insta_food/presentation/widgets/rating_container.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class Thumbnail extends StatefulWidget {
  final BestSellerItem item;
  const Thumbnail({super.key, required this.item});

  @override
  State<Thumbnail> createState() => _ThumbnailState();
}

class _ThumbnailState extends State<Thumbnail> {
  @override
  Widget build(BuildContext context) {
    ValueNotifier<int> qty = ValueNotifier<int>(1);

    return SizedBox(
      width: 150,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(AppAssets.banner, fit: BoxFit.cover),
                      Text(
                        AppStrings.newProduct,
                        style: AppTextStyles.fontWhiteMed,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  widget.item.itemName,
                  style: AppTextStyles.fontBlackMed,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 150,
                  ), // Adjust width as needed
                  child: Text(
                    widget.item.itemDescription ?? "",
                    style: AppTextStyles.small,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2, // Always specify maxLines with ellipsis
                  ),
                ),
                SizedBox(height: 8),
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
                    spacing: 8,
                    children: [
                      ValueListenableBuilder<int>(
                        valueListenable: qty,
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
                                initNumber: qty.value,
                                counterCallback: (v) => qty.value = v,
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
                            quantity: qty.value,
                          );
                          final isAuthed =
                              context.read<AuthCubit>().state
                                  is! Unauthenticated;
                          context.read<CartCubit>().addOrUpdate(cartitem).then((
                            _,
                          ) {
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
          ),
        ],
      ),
    );
  }
}
