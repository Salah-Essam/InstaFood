import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/presentation/features/cart/logic/cart_cubit.dart';
import 'package:insta_food/presentation/features/cart/logic/cart_state.dart';
import 'package:insta_food/presentation/features/order/logic/order_cubit.dart';
import 'package:insta_food/presentation/features/order/logic/order_state.dart';
import 'package:insta_food/presentation/widgets/shared_scaffold.dart';
import 'package:insta_food/presentation/features/order/presentation/widgets/confirm_order/confirm_order_widgets.dart';

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
        const ShippingAddressSection(),
              const SizedBox(height: 8),
        const OrderSummaryHeader(),
              const SizedBox(height: 8),
        const LightDivider(),
              const SizedBox(height: 8),
        const OrderSummaryList(),
        const LightDivider(),
              const SizedBox(height: 8),
        const TotalsSection(),
              const SizedBox(height: 16),
        PlaceOrderButton(disabled: state is OrderPlacing),
            ],
          );
        },
      ),
    );
  }
}
 
