import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/core/utils/app_strings.dart';
import 'package:insta_food/presentation/features/filter/presentation/cubit/filter_cubit.dart';

class SortRow extends StatelessWidget {
  const SortRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterCubit, FilterState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 8,
          children: [
            Text(AppStrings.sortBy, style: AppTextStyles.small),
            InkWell(
              onTap: () {},
              child: Text("asc", style: AppTextStyles.fontPrimarySmall),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                context.read<FilterCubit>().resetFilter();
              },
              child: SvgPicture.asset(
                AppAssets.filter,
                height: 20,
                width: 20,
                fit: BoxFit.cover,
              ),
            ),
          ],
        );
      },
    );
  }
}
