import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
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
            List<Widget> children = [
              _header(),
              const SizedBox(height: 8),
              Container(height: 1, color: AppColors.lightOrange),
              const SizedBox(height: 16),
            ];

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
              children.add(Center(child: Text(state.message, style: AppTextStyles.mediumText.copyWith(color: Colors.white))));
            } else {
              children.add(const _EmptyCart());
            }

            return SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children));
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
          children: [
            Image.asset('assets/icons/cart_drawer_icon.png', width: 24, height: 24),
            const SizedBox(width: 8),
            Text('Cart', style: AppTextStyles.greeting),
          ],
        ),
        const SizedBox(height: 8),
        Image.asset('assets/icons/Line1_drawer.png', height: 2, fit: BoxFit.fill),
      ],
    );

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 24),
  Image.asset('assets/icons/Line4_drawer.png', height: 2, fit: BoxFit.fill),
  const SizedBox(height: 24),
  Center(child: Image.asset('assets/icons/Add to car Icon.png', width: 120, height: 120)),
        const SizedBox(height: 16),
        Text('Want To Add\nSomething?', textAlign: TextAlign.center, style: AppTextStyles.greeting),
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
        final loaded = state is CartLoaded ? state : CartLoaded(items: const []);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('You have ${loaded.items.length} items in the cart', style: AppTextStyles.mediumText.copyWith(color: Colors.white)),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: loaded.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
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
                          placeholder: (_, __) => const Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))),
                          errorWidget: (_, __, ___) => Container(
                            color: Colors.white24,
                            child: const Icon(Icons.image_not_supported_outlined, color: Colors.white70, size: 20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(it.itemName, style: AppTextStyles.mediumText.copyWith(color: Colors.white)),
                          Text(it.restaurantName, style: AppTextStyles.mediumText.copyWith(color: AppColors.lightOrange, fontSize: 12)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.circle, size: 6, color: Colors.white70),
                              const SizedBox(width: 6),
                              Text('${(it.options['size'] ?? '').toString().isEmpty ? 'Size' : it.options['size']}  •  x${it.quantity}',
                                  style: AppTextStyles.mediumText.copyWith(color: Colors.white, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                                Text('\$${it.unitPrice.toStringAsFixed(2)}', style: AppTextStyles.mediumText.copyWith(color: Colors.white)),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () => context.read<CartCubit>().remove(it.cartItemId),
                          child: const Icon(Icons.delete_outline, color: Colors.white70, size: 20),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
            const DottedLine(dashLength: 4, dashGapLength: 4, lineThickness: 1, dashColor: Colors.white24),
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
        _row('Total', t.total.toStringAsFixed(2), s.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _row(String l, String r, TextStyle style) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(l, style: style),
          Text('\$'+r, style: style),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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

