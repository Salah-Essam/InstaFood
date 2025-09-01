import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/presentation/features/cart/logic/cart_cubit.dart';
import 'package:insta_food/presentation/features/cart/logic/cart_state.dart';
import 'package:insta_food/presentation/features/cart/data/models/cart_item_model.dart';
import 'package:insta_food/presentation/features/order/logic/order_cubit.dart';
import 'package:insta_food/presentation/features/order/logic/order_state.dart';
import 'package:insta_food/presentation/widgets/shared_scaffold.dart';
import 'package:go_router/go_router.dart';

class ConfirmOrderPage extends StatelessWidget {
  const ConfirmOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      appBarTitle: 'Confirm Order',
      pageDetails: BlocConsumer<OrderCubit, OrderState>(
        listener: (context, state) {
          if (state is OrderPlaced) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Order placed successfully')),);
            Navigator.of(context).pop();
          } else if (state is OrderError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),);
          }
        },
        builder: (context, state) {
          final cartState = context.watch<CartCubit>().state;
          if (cartState is! CartLoaded || cartState.items.isEmpty) {
            return Center(
              child: Text('Your cart is empty', style: AppTextStyles.mediumText),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ShippingAddressSection(),
              const SizedBox(height: 8),
              _OrderSummaryHeader(),
              const SizedBox(height: 8),
              const _LightDivider(),
              const SizedBox(height: 8),
              _OrderSummaryList(),
              const _LightDivider(),
              const SizedBox(height: 8),
              _TotalsSection(),
              const SizedBox(height: 16),
              _PlaceOrderButton(disabled: state is OrderPlacing),
            ],
          );
        },
      ),
    );
  }
}

class _ShippingAddressSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Shipping Address', style: AppTextStyles.greeting.copyWith(color: Colors.black)),
        const SizedBox(height: 8),
        SizedBox(
          width: 323,
          height: 35,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.primaryYellow,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: Colors.black87, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('778 Locust View Drive Oaklanda, CA',
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.mediumText.copyWith(color: Colors.black87)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OrderSummaryHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Order Summary',
            style: AppTextStyles.mediumText.copyWith(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w400, // not bold
            ),
          ),
        ),
        InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Row(
            children: [
              const Icon(Icons.edit_outlined, size: 16, color: AppColors.lightOrange),
              const SizedBox(width: 4),
              Text('Edit', style: AppTextStyles.mediumText.copyWith(color: AppColors.lightOrange, fontSize: 14, fontWeight: FontWeight.w400)),
            ],
          ),
        ),
      ],
    );
  }
}

class _LightDivider extends StatelessWidget {
  const _LightDivider();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 323,
      child: Divider(
        color: AppColors.orange2, // #FFD8C7
        height: 1,
        thickness: 1,
      ),
    );
  }
}

class _OrderSummaryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = context.watch<CartCubit>().state as CartLoaded;
    return Expanded(
      child: ListView.separated(
        itemCount: s.items.length,
        separatorBuilder: (_, __) => const _DividerWithSpacing(),
        itemBuilder: (context, i) {
          final it = s.items[i];
          return _OrderItemRow(item: it);
        },
      ),
    );
  }
}

class _DividerWithSpacing extends StatelessWidget {
  const _DividerWithSpacing();
  @override
  Widget build(BuildContext context) => Column(
        children: const [
          SizedBox(height: 6),
          _LightDivider(),
          SizedBox(height: 6),
        ],
      );
}

class _OrderItemRow extends StatelessWidget {
  final CartItemModel item;
  const _OrderItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
  final it = item;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(it.imageUrl, width: 44, height: 44, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(it.itemName, style: AppTextStyles.mediumText.copyWith(color: Colors.black)),
                    ),
                    IconButton(
                      onPressed: () => context.read<CartCubit>().remove(it.cartItemId),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.delete_outline, color: AppColors.primaryOrange, size: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(_formatDate(it.addedAt ?? it.updatedAt), style: AppTextStyles.mediumText.copyWith(fontSize: 12, color: Colors.black54)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _iconPill(Icons.remove, enabled: it.quantity > 1, onTap: it.quantity > 1
                        ? () {
                            context.read<CartCubit>().addOrUpdate(it.copyWith(quantity: it.quantity - 1));
                          }
                        : null),
                    const SizedBox(width: 6),
                    Text('${it.quantity}', style: AppTextStyles.mediumText.copyWith(color: Colors.black)),
                    const SizedBox(width: 6),
                    _iconPill(Icons.add, enabled: true, onTap: () {
                      context.read<CartCubit>().addOrUpdate(it.copyWith(quantity: it.quantity + 1));
                    }),
                    const Spacer(),
                    Text('\$${it.unitPrice.toStringAsFixed(2)}', style: AppTextStyles.mediumText.copyWith(color: AppColors.primaryOrange)),
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      backgroundColor: AppColors.orange2,
                      foregroundColor: AppColors.primaryOrange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () => context.read<CartCubit>().remove(it.cartItemId),
                    child: const Text('Cancel Order'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? dt) {
  dt ??= DateTime.now();
    // Simple date-time format: 29 Nov, 12:00 pm
    final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final d = dt.day.toString().padLeft(2, '0');
    final m = months[dt.month - 1];
    int hour = dt.hour;
    final ampm = hour >= 12 ? 'pm' : 'am';
    hour = hour % 12; if (hour == 0) hour = 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$d $m, $hour:$minute $ampm';
  }

  Widget _iconPill(IconData icon, {required bool enabled, VoidCallback? onTap}) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: enabled ? AppColors.primaryOrange.withOpacity(0.1) : AppColors.orange2,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, size: 16, color: enabled ? AppColors.primaryOrange : AppColors.primaryOrange.withOpacity(0.6)),
      ),
    );
  }
}

class _TotalsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = context.watch<CartCubit>().state as CartLoaded;
    final s = AppTextStyles.mediumText.copyWith(color: Colors.black);
    return Column(
      children: [
        _row('Subtotal', t.subtotal.toStringAsFixed(2), s),
        _row('Tax and Fees', t.tax.toStringAsFixed(2), s),
        _row('Delivery', t.delivery.toStringAsFixed(2), s),
        const SizedBox(height: 8),
        const _LightDivider(),
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

class _PlaceOrderButton extends StatelessWidget {
  final bool disabled;
  const _PlaceOrderButton({required this.disabled});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.orange2, // #FFD8C7
          foregroundColor: AppColors.primaryOrange, // text color orange
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onPressed: disabled
            ? null
            : () {
                // Navigate to Payment 
                context.pushNamed('payment');
              },
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: Text('Place Order'),
        ),
      ),
    );
  }
}
