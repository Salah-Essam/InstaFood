import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/core/utils/app_strings.dart';
import 'package:insta_food/core/utils/app_alerts.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';
import 'package:insta_food/presentation/features/items/data/model/item_size.dart';
import 'package:insta_food/presentation/features/items/presentation/widgets/app_counter.dart';
import 'package:insta_food/presentation/features/items/presentation/widgets/fav_button.dart';
import 'package:insta_food/presentation/features/items/presentation/widgets/radio_button_collection.dart';
import 'package:insta_food/presentation/features/items/presentation/widgets/rating_container.dart';
import 'package:insta_food/presentation/widgets/app_button_onb.dart';
import 'package:insta_food/presentation/widgets/cached_image.dart';
import 'package:insta_food/presentation/features/cart/data/models/cart_item_model.dart';
import 'package:insta_food/presentation/features/cart/logic/cart_cubit.dart';
import 'package:insta_food/presentation/features/cart/logic/cart_state.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_state.dart';
import 'package:insta_food/presentation/features/drawer/presentation/cubit/drawer_cubit.dart';
import 'package:insta_food/presentation/features/drawer/presentation/view/app_drawer.dart';

class ItemPage extends StatefulWidget {
  final ItemModel item;
  const ItemPage({super.key, required this.item});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  final ValueNotifier<ItemSize> _size = ValueNotifier<ItemSize>(
    ItemSize.medium,
  );
  int _qty = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryYellow,
      endDrawer: BlocBuilder<DrawerCubit, DrawerState>(
        builder: (context, drawerState) {
          if (drawerState is DrawerOpened) {
            return AppDrawer(drawerSelected: drawerState.type);
          }
          return AppDrawer(drawerSelected: DrawerType.profile);
        },
      ),
      onEndDrawerChanged: (isOpen) {
        if (!isOpen) context.read<DrawerCubit>().closeDrawer();
      },
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60, right: 35, left: 35),
            child: Row(
              spacing: 3,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 2),
                    child: InkWell(
                      child: SvgPicture.asset(
                        AppAssets.backArrow,
                        fit: BoxFit.fill,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                Text(widget.item.itemName, style: AppTextStyles.header),

                Spacer(),
                FavButton(),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () =>
                      context.read<DrawerCubit>().openDrawer(DrawerType.cart),
                  child: SvgPicture.asset(
                    AppAssets.cart,
                    width: 26,
                    height: 26,
                  ),
                ),
              ],
            ),
          ),
          Align(alignment: Alignment.centerLeft, child: RatingContainer()),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: SizedBox(
                width: double.infinity,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 35,
                      vertical: 33,
                    ),
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(36),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(36),
                          child: CachedImage(
                            item: widget.item,
                            width: 323,
                            height: 223,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.symmetric(
                            horizontal: BorderSide(
                              color: AppColors.border,
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ValueListenableBuilder<ItemSize>(
                                valueListenable: _size,
                                builder: (_, size, __) {
                                  final price =
                                      (widget.item.itemPrice +
                                          size.priceModifier) *
                                      _qty;
                                  return Text(
                                    "\$${price.toStringAsFixed(2)}",
                                    style: AppTextStyles.itemPagePrice,
                                  );
                                },
                              ),
                              Counter(
                                initNumber: _qty,
                                counterCallback: (v) =>
                                    setState(() => _qty = v),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(widget.item.itemName, style: AppTextStyles.header),
                      Text(
                        widget.item.itemDescription!,
                        style: AppTextStyles.mediumText,
                      ),
                      SizedBox(height: 29),
                      Text(AppStrings.portions, style: AppTextStyles.header),
                      RadioButtonCollection(controller: _size),
                      BlocListener<CartCubit, CartState>(
                        listenWhen: (p, n) => n is CartActionBlocked,
                        listener: (context, state) {
                          if (state is CartActionBlocked &&
                              state.reason == 'login_required') {
                            AppAlerts.showLoginRequiredDialog(context);
                          }
                        },
                        child: AppButton(
                          width: 180,
                          onPressed: () {
                            final item = CartItemModel.fromItem(
                              item: widget.item,
                              size: _size.value,
                              quantity: _qty,
                            );
                            final isAuthed =
                                context.read<AuthCubit>().state
                                    is! Unauthenticated;
                            context.read<CartCubit>().addOrUpdate(item).then((
                              _,
                            ) {
                              if (!context.mounted) return;
                              if (isAuthed) {
                                AppAlerts.showSuccessDialog(
                                  context,
                                  title: 'Added to cart successfully!',
                                  imageAsset:
                                      'assets/images/greencheckmark.jpg',
                                );
                              }
                            });
                          },
                          borderRadius: 44.79,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                AppAssets.orderBag,
                                fit: BoxFit.fitHeight,
                              ),
                              SizedBox(width: 14),
                              Text(
                                AppStrings.addToCart,
                                style: AppTextStyles.button,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
