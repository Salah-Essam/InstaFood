import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:insta_food/core/utils/app_strings.dart';
import 'dart:math' show pi;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/presentation/features/cart/logic/cart_cubit.dart';
import 'package:insta_food/presentation/features/cart/logic/cart_state.dart';

class CartDrawer extends StatelessWidget {
  const CartDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            List<Widget> children = [_header(), const SizedBox(height: 16)];

            if (state is CartLoading) {
              children.add(const Center(child: CircularProgressIndicator()));
            } else if (state is CartLoaded) {
              if (state.items.isEmpty) {
                children.add(const _EmptyCart());
              } else {
                children.add(_CartList());
                children.add(const SizedBox(height: 12));
                children.add(_Totals());
                children.add(const SizedBox(height: 16));
                children.add(_CheckoutButton());
              }
            } else if (state is CartError) {
              children.add(
                Center(
                  child: Text(
                    state.message,
                    style: AppTextStyles.mediumText.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            } else {
              children.add(const _EmptyCart());
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget _header() => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/icons/cart_drawer_icon.png', width: 24, height: 24),
        const SizedBox(width: 8),
        SizedBox(
          height: 24,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Cart',
              style: const TextStyle(
                fontFamily: 'LeagueSpartan',
                fontWeight: FontWeight.w700,
                fontSize: 24,
                height: 1.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    ),
    const SizedBox(height: 10),
    // Figma: one thin 1px line below the header (width ~259)
    Transform.rotate(
      angle: -0.22 * pi / 180,
      child: Container(
        margin: const EdgeInsets.only(left: 33),
        height: 1,
        width: 259.0018,
        color: const Color(0xFFFFDECF),
      ),
    ),
  ],
);

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ), // 20px below header line per Figma (165 - 145)
        Center(
          child: SizedBox(
            width: 153,
            child: Text(
              AppStrings.yourCartIsEmpty,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'LeagueSpartan',
                fontWeight: FontWeight.w500,
                fontSize: 20,
                height: 1.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 143,
        ), // 308 - 165 = 143px between caption and plus icon
        // Big plus circular icon (184x184, radius 51.54), centered
        Center(
          child: Container(
            width: 184,
            height: 184,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(51.54),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(51.54),
              child: Image.asset(
                'assets/icons/Add to car Icon.png',
                width: 184,
                height: 184,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            AppStrings.wantToAddSomething,
            textAlign: TextAlign.center,
            style: AppTextStyles.greeting,
          ),
        ),
      ],
    );
  }
}

class _CartList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      buildWhen: (p, n) => n is CartLoaded,
      builder: (context, state) {
        final loaded = state is CartLoaded
            ? state
            : CartLoaded(items: const []);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'You have ${loaded.items.length} items in the cart',
                style: AppTextStyles.mediumText.copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: loaded.items.length,
              // No line between products per Figma; keep only spacing
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, i) {
                final it = loaded.items[i];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: 54,
                        height: 54,
                        child: CachedNetworkImage(
                          imageUrl: it.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => const Center(
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (_, __, ___) => Container(
                            color: Colors.white24,
                            child: const Icon(
                              Icons.image_not_supported_outlined,
                              color: Colors.white70,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            it.itemName,
                            style: AppTextStyles.mediumText.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            it.restaurantName,
                            style: AppTextStyles.mediumText.copyWith(
                              color: AppColors.lightOrange,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.circle,
                                size: 6,
                                color: Colors.white70,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${(it.options['size'] ?? '').toString().isEmpty ? 'Size' : it.options['size']}  •  x${it.quantity}',
                                style: AppTextStyles.mediumText.copyWith(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${it.unitPrice.toStringAsFixed(2)}',
                          style: AppTextStyles.mediumText.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () =>
                              context.read<CartCubit>().remove(it.cartItemId),
                          child: const Icon(
                            Icons.delete_outline,
                            color: Colors.white70,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            // Dotted line moved to before the Total row inside _Totals
          ],
        );
      },
    );
  }
}

class _Totals extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<CartCubit>().state;
    if (state is! CartLoaded) return const SizedBox.shrink();
    final t = state;
    TextStyle s = AppTextStyles.mediumText.copyWith(color: Colors.white);
    return Column(
      children: [
        _row('Subtotal', t.subtotal.toStringAsFixed(2), s),
        _row('Tax and Fees', t.tax.toStringAsFixed(2), s),
        _row('Delivery', t.delivery.toStringAsFixed(2), s),
        const SizedBox(height: 8),
        // Dotted line appears right before the Total row per Figma
        const Padding(
          padding: EdgeInsets.only(left: 33.0),
          child: SizedBox(
            width: 259.0018,
            child: DottedLine(
              dashLength: 4,
              dashGapLength: 4,
              lineThickness: 1,
              dashColor: Colors.white24,
            ),
          ),
        ),
        const SizedBox(height: 8),
        _row(
          'Total',
          t.total.toStringAsFixed(2),
          s.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _row(String l, String r, TextStyle style) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(l, style: style),
      Text('\$' + r, style: style),
    ],
  );
}

class _CheckoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryYellow,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () {},
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: Text('Checkout'),
        ),
      ),
    );
  }
}
