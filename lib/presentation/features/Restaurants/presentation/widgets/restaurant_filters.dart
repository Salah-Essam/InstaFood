import 'package:flutter/material.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';

enum RestaurantFilterType { all, address, name, cuisine }

class RestaurantFilters extends StatefulWidget {
  final void Function(RestaurantFilterType filterType, String? query) onFilterChanged;
  const RestaurantFilters({super.key, required this.onFilterChanged});

  @override
  State<RestaurantFilters> createState() => _RestaurantFiltersState();
}

class _RestaurantFiltersState extends State<RestaurantFilters> {
  RestaurantFilterType active = RestaurantFilterType.all;
  final TextEditingController _controller = TextEditingController();

  void _emit() {
    widget.onFilterChanged(active, active == RestaurantFilterType.all ? null : _controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _chip(RestaurantFilterType.all, 'All'),
              _chip(RestaurantFilterType.address, 'Address'),
              _chip(RestaurantFilterType.name, 'Name'),
              _chip(RestaurantFilterType.cuisine, 'Cuisine'),
            ],
          ),
          if (active != RestaurantFilterType.all)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: _controller,
                onChanged: (_) => _emit(),
                decoration: InputDecoration(
                  hintText: 'Enter ${active.name}...',
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _chip(RestaurantFilterType type, String label) {
    final selected = active == type;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label, style: AppTextStyles.small.copyWith(color: selected ? AppColors.white : AppColors.textDarkBrown)),
        selected: selected,
        onSelected: (_) {
          setState(() { active = type; });
          _emit();
        },
        selectedColor: AppColors.primaryOrange,
        backgroundColor: AppColors.lightOrange,
      ),
    );
  }
}
