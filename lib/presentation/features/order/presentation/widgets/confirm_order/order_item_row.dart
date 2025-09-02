import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/presentation/features/cart/data/models/cart_item_model.dart';
import 'package:insta_food/presentation/features/cart/logic/cart_cubit.dart';

class OrderItemRow extends StatelessWidget {
  const OrderItemRow({super.key, required this.item});

  final CartItemModel item;

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
            child: Image.network(
              it.imageUrl,
              width: 44,
              height: 44,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left: name + date stacked with no extra gap
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            it.itemName,
                            style: AppTextStyles.mediumText.copyWith(
                              color: Colors.black,
                            ),
                          ),
                          // date-time placed instantly below the name (no SizedBox in between)
                          Text(
                            _formatDate(it.addedAt ?? it.updatedAt),
                            style: AppTextStyles.mediumText.copyWith(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Cancel Order directly below date/time
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              backgroundColor: AppColors.orange2,
                              foregroundColor: AppColors.primaryOrange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () =>
                                context.read<CartCubit>().remove(it.cartItemId),
                            child: const Text('Cancel Order'),
                          ),
                        ],
                      ),
                    ),
                    // Right: trash icon on top, +/- below it with price on the right
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () =>
                              context.read<CartCubit>().remove(it.cartItemId),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(
                            Icons.delete_outline,
                            color: AppColors.primaryOrange,
                            size: 18,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _iconPill(
                              Icons.remove,
                              enabled: it.quantity > 1,
                              onTap: it.quantity > 1
                                  ? () {
                                      context.read<CartCubit>().addOrUpdate(
                                        it.copyWith(quantity: it.quantity - 1),
                                      );
                                    }
                                  : null,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${it.quantity}',
                              style: AppTextStyles.mediumText.copyWith(
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 6),
                            _iconPill(
                              Icons.add,
                              enabled: true,
                              onTap: () {
                                context.read<CartCubit>().addOrUpdate(
                                  it.copyWith(quantity: it.quantity + 1),
                                );
                              },
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '\$${it.unitPrice.toStringAsFixed(2)}',
                              style: AppTextStyles.mediumText.copyWith(
                                color: AppColors.primaryOrange,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                // Cancel button moved up under date/time
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? dt) {
    dt ??= DateTime.now();
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final d = dt.day.toString().padLeft(2, '0');
    final m = months[dt.month - 1];
    int hour = dt.hour;
    final ampm = hour >= 12 ? 'pm' : 'am';
    hour = hour % 12;
    if (hour == 0) hour = 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$d $m, $hour:$minute $ampm';
  }

  Widget _iconPill(
    IconData icon, {
    required bool enabled,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: enabled
              ? AppColors.primaryOrange.withAlpha(25)
              : AppColors.orange2,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          icon,
          size: 16,
          color: enabled
              ? AppColors.primaryOrange
              : AppColors.primaryOrange.withAlpha(150),
        ),
      ),
    );
  }
}
