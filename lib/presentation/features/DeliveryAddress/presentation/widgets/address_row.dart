import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/presentation/features/DeliveryAddress/data/models/address_model.dart';
import 'package:insta_food/presentation/features/DeliveryAddress/presentation/cubit/address_cubit.dart';

class AddressRow extends StatelessWidget {
  const AddressRow({
    super.key,
    required this.address,
    required this.selectedId,
  });
  final AddressModel address;
  final int selectedId;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SvgPicture.asset(
              AppAssets.navBarHome,
              colorFilter: ColorFilter.mode(
                AppColors.primaryOrange,
                BlendMode.srcIn,
              ),
              height: 35,
              width: 35,
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.title,
                    style: AppTextStyles.header,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    address.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.small,
                  ),
                ],
              ),
            ),
            const Spacer(),
            Radio<int>(
              activeColor: AppColors.primaryOrange,
              value: address.id,
              groupValue: selectedId,
              onChanged: (value) {
                if (value != null) {
                  context.read<AddressCubit>().selectAddress(value);
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
