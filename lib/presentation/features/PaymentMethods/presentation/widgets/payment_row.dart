import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/presentation/features/PaymentMethods/data/models/payment_model.dart';
import 'package:insta_food/presentation/features/PaymentMethods/presentation/cubit/payment_cubit.dart';

class PaymentRow extends StatelessWidget {
  const PaymentRow({
    super.key,
    required this.payment,
    required this.selectedId,
  });
  final PaymentModel payment;
  final int selectedId;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 50,
              child: SvgPicture.asset(
                payment.icon,
                colorFilter: ColorFilter.mode(
                  AppColors.primaryOrange,
                  BlendMode.srcIn,
                ),
                height: 35,
                width: 35,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                payment.title,
                style: AppTextStyles.header,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Radio<int>(
              activeColor: AppColors.primaryOrange,
              value: payment.id,
              groupValue: selectedId,
              onChanged: (value) {
                if (value != null) {
                  context.read<PaymentCubit>().selectPayment(value);
                }
              },
            ),
          ],
        ),
        Divider(color: AppColors.lightOrange),
      ],
    );
  }
}
