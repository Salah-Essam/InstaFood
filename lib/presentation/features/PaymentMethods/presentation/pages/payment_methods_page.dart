import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_food/core/routes/router_constants.dart'
    show RouterConstants;

import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/presentation/features/PaymentMethods/presentation/cubit/payment_cubit.dart';
import 'package:insta_food/presentation/features/PaymentMethods/presentation/widgets/payment_row.dart';
import 'package:insta_food/presentation/widgets/app_button_onb.dart';
import 'package:insta_food/presentation/widgets/shared_scaffold.dart';

class PaymentMethodsPage extends StatelessWidget {
  const PaymentMethodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentCubit(),
      child: SharedScaffold(
        appBarTitle: "PaymentMethods",
        pageDetails: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            children: [
              // Divider(color: AppColors.lightOrange),
              Expanded(
                child: BlocBuilder<PaymentCubit, PaymentState>(
                  builder: (context, state) {
                    if (state is PaymentLoaded) {
                      return ListView.builder(
                        itemCount: state.payment.length,
                        itemBuilder: (context, index) {
                          final item = state.payment[index];
                          return PaymentRow(
                            payment: item,
                            selectedId: state.selectedId,
                          );
                        },
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),

              SafeArea(
                minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Center(
                  child: AppButton(
                    onPressed: () {
                      context.push(RouterConstants.addNewPaymentPage);
                    },
                    backgroundColor: AppColors.lightOrange,
                    width: 200,
                    borderRadius: 24,
                    child: Text(
                      "Add New Card",
                      style: AppTextStyles.buttonOrangeText,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
