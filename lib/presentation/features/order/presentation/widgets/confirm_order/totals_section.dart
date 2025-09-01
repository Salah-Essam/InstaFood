import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/presentation/features/cart/logic/cart_cubit.dart';
import 'package:insta_food/presentation/features/cart/logic/cart_state.dart';
import 'light_dividers.dart';

class TotalsSection extends StatelessWidget {
  const TotalsSection({super.key});
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
        const LightDivider(),
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
