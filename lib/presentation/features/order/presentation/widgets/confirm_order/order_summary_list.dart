import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_food/presentation/features/cart/logic/cart_cubit.dart';
import 'package:insta_food/presentation/features/cart/logic/cart_state.dart';
import 'order_item_row.dart';
import 'light_dividers.dart';

class OrderSummaryList extends StatelessWidget {
  const OrderSummaryList({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<CartCubit>().state as CartLoaded;
    return Expanded(
      child: ListView.separated(
        itemCount: s.items.length,
        separatorBuilder: (_, __) => const DividerWithSpacing(),
        itemBuilder: (context, i) {
          final it = s.items[i];
          return OrderItemRow(item: it);
        },
      ),
    );
  }
}
