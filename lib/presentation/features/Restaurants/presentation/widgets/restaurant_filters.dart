import 'package:flutter/material.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';

enum RestaurantFilterType { all, address, name, cuisine }

class RestaurantFilters extends StatefulWidget {
  final void Function(RestaurantFilterType filterType, String? query) onFilterChanged;
  const RestaurantFilters({super.key, required this.onFilterChanged});

  @override
  State<RestaurantFilters> createState() => RestaurantFiltersState();
}

class RestaurantFiltersState extends State<RestaurantFilters> {
  RestaurantFilterType active = RestaurantFilterType.all;
  final TextEditingController controller = TextEditingController();

  void emit() {
    widget.onFilterChanged(active, active == RestaurantFilterType.all ? null : controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              const gap = 8.0;
              final per = ((constraints.maxWidth - (3 * gap)) / 4).clamp(70.0, double.infinity);
              return Row(
                children: [
                  seg('All', RestaurantFilterType.all, per),
                  const SizedBox(width: gap),
                  seg('Address', RestaurantFilterType.address, per),
                  const SizedBox(width: gap),
                  seg('Name', RestaurantFilterType.name, per),
                  const SizedBox(width: gap),
                  seg('Cuisine', RestaurantFilterType.cuisine, per),
                ],
              );
            },
          ),
          if (active != RestaurantFilterType.all)
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: TextField(
                controller: controller,
                onChanged: (_) => emit(),
                decoration: InputDecoration(
                  hintText: 'Enter ${active.name}...',
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget seg(String text, RestaurantFilterType type, double width) {
    final isSelected = active == type;
    return SizedBox(
      width: width,
      height: 32,
      child: InkWell(
        onTap: () {
          setState(() {
            active = type;
            controller.clear();
          });
          emit();
        },
        borderRadius: BorderRadius.circular(38),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryOrange : AppColors.orange2,
            borderRadius: BorderRadius.circular(38),
            border: Border.all(
              color: isSelected ? AppColors.primaryOrange : AppColors.border,
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          padding: const EdgeInsetsDirectional.only(start: 8, end: 8, top: 2),
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.mediumText.copyWith(
              fontSize: 12,
              color: isSelected ? Colors.white : AppColors.primaryOrange,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
