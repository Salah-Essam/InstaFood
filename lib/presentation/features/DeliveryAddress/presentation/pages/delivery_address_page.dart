import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_food/core/routes/router_constants.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/presentation/features/DeliveryAddress/presentation/cubit/address_cubit.dart';
import 'package:insta_food/presentation/features/DeliveryAddress/presentation/widgets/address_row.dart';
import 'package:insta_food/presentation/widgets/app_button_onb.dart';
import 'package:insta_food/presentation/widgets/shared_scaffold.dart';

class DeliveryAddressPage extends StatelessWidget {
  const DeliveryAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddressCubit(),
      child: SharedScaffold(
        appBarTitle: "Delivery Address",
        pageDetails: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            children: [
              // Divider(color: AppColors.lightOrange),
              Expanded(
                child: BlocBuilder<AddressCubit, AddressState>(
                  builder: (context, state) {
                    if (state is AddressLoaded) {
                      return ListView.builder(
                        itemCount: state.addresses.length,
                        itemBuilder: (context, index) {
                          final address = state.addresses[index];
                          return AddressRow(
                            address: address,
                            selectedId: state.selectedId,
                          );
                        },
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 128),
                child: Center(
                  child: AppButton(
                    onPressed: () {
                      context.push(RouterConstants.addNewAddressPage);
                    },
                    backgroundColor: AppColors.lightOrange,
                    width: 160,
                    borderRadius: 24,
                    child: Text(
                      "Add New Address",
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
