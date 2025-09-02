import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/presentation/features/cart/logic/cart_cubit.dart';
import 'package:insta_food/presentation/features/cart/logic/cart_state.dart';
import 'package:insta_food/presentation/features/order/logic/order_cubit.dart';
import 'package:insta_food/presentation/features/order/logic/order_state.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_food/core/routes/router_constants.dart';
import 'package:insta_food/presentation/widgets/shared_scaffold.dart';
import 'package:insta_food/presentation/features/order/presentation/widgets/payment/address_pill.dart';
import 'package:insta_food/presentation/features/order/presentation/widgets/payment/common_widgets.dart'
    as pw;
import 'package:insta_food/presentation/features/order/presentation/widgets/payment/payment_method_row.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      appBarTitle: 'Payment',
      pageDetails: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          final isLoaded = state is CartLoaded;
          final items = isLoaded ? state.items : const [];
          final total = isLoaded ? state.total : 0.0;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Shipping Address
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Shipping Address',
                      style: AppTextStyles.greeting.copyWith(
                        color: Colors.black,
                      ),
                    ),
                    const pw.SmallPencilEdit(),
                  ],
                ),
                const SizedBox(height: 8),
                const AddressPill(
                  address: '778 Locust View Drive Oaklanda, CA',
                ),
                const SizedBox(height: 12),
                const pw.LightDivider(),

                const SizedBox(height: 12),
                // Order Summary
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Order Summary',
                        style: AppTextStyles.mediumText.copyWith(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const pw.EditPill(),
                  ],
                ),
                const SizedBox(height: 8),
                ...items.map(
                  (it) => Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  it.itemName,
                                  style: AppTextStyles.mediumText.copyWith(
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${it.quantity} items',
                                style: AppTextStyles.mediumText.copyWith(
                                  color: AppColors.lightOrange,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: AppTextStyles.mediumText.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const pw.LightDivider(),

                const SizedBox(height: 12),
                // Payment Method
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Payment Method',
                        style: AppTextStyles.mediumText.copyWith(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const pw.EditPill(),
                  ],
                ),
                const SizedBox(height: 8),
                const PaymentMethodRow(),
                const SizedBox(height: 12),
                const pw.LightDivider(),

                const SizedBox(height: 12),
                // Delivery Time
                Text(
                  'Delivery Time',
                  style: AppTextStyles.mediumText.copyWith(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Estimated Delivery',
                      style: AppTextStyles.mediumText.copyWith(
                        color: Colors.black54,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '25 mins',
                      style: AppTextStyles.mediumText.copyWith(
                        color: AppColors.primaryOrange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const pw.LightDivider(),

                const SizedBox(height: 20),
                BlocBuilder<OrderCubit, OrderState>(
                  builder: (context, orderState) {
                    final placing = orderState is OrderPlacing;
                    return Center(
                      child: SizedBox(
                        width: 220,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.lightOrange,
                            foregroundColor: AppColors.primaryOrange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: placing
                              ? null
                              : () async {
                                  final cubit = context.read<OrderCubit>();
                                  if (!isLoaded || items.isEmpty) {
                                    // Fallback navigation to keep UX flow moving (no order stored)
                                    if (context.mounted) {
                                      context.go(
                                        RouterConstants.orderConfirmed,
                                      );
                                    }
                                    return;
                                  }
                                  await cubit.placeOrder(
                                    shippingAddress:
                                        '778 Locust View Drive Oaklanda, CA',
                                  );
                                  final st = cubit.state;
                                  if (st is OrderPlaced && context.mounted) {
                                    context.go(
                                      RouterConstants.orderConfirmed,
                                      extra: st.orderId,
                                    );
                                  }
                                },
                          child: Text(placing ? 'Processing…' : 'Pay Now'),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
    );
  }
}
