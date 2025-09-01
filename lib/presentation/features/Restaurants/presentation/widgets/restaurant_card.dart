import 'package:flutter/material.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/presentation/features/Restaurants/data/model/restaurant_model.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(restaurant.restaurantName, style: AppTextStyles.mediumText),
          const SizedBox(height: 4),
            Text(restaurant.type, style: AppTextStyles.small),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(child: Text(restaurant.address, style: AppTextStyles.small, maxLines: 1, overflow: TextOverflow.ellipsis)),
              if (restaurant.parkingLot)
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.local_parking, size: 18, color: AppColors.primaryOrange),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
