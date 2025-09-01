import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/presentation/features/cart/logic/cart_cubit.dart';
import 'package:insta_food/presentation/features/cart/logic/cart_state.dart';

class OrderSummaryCompact extends StatelessWidget {
  const OrderSummaryCompact({super.key});
  @override
  Widget build(BuildContext context) {
    final s = context.watch<CartCubit>().state;
    if (s is! CartLoaded) return const SizedBox.shrink();
    return Column(
      children: [
        ...s.items.map((it) => Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      it.itemName,
                      style: AppTextStyles.mediumText.copyWith(color: Colors.black87),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('${it.quantity} items',
                      style: AppTextStyles.mediumText.copyWith(color: AppColors.lightOrange, fontSize: 12)),
                ],
              ),
            )),
      ],
    );
  }
}
