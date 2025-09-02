import 'package:insta_food/presentation/features/filter/data/enum/catagories_enum.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';

class ListFilter {
  static List<ItemModel> applyFilters({
    required List<ItemModel> items,
    String? subCategory,
    FoodCategory? category,
    double? maxPrice,
  }) {
    return items.where((item) {
      // Category filter

      if (category != null) {
        // Check if item description contains ANY of the category's keywords (subcategories)
        if (subCategory == null) {
          final hasMatchingSubCategory = category.keywords.any(
            (subCategory) =>
                item.itemDescription?.toLowerCase().contains(
                  subCategory.toLowerCase(),
                ) ??
                false,
          );
          dynamic hasExclusionMatch;

          hasExclusionMatch = category.exclusionKeywords.any(
            (keyword) =>
                item.itemDescription?.toLowerCase().contains(
                  keyword.toLowerCase(),
                ) ??
                false,
          );
          // Include if matches inclusion keywords BUT NOT exclusion keywords
          if (!hasMatchingSubCategory || hasExclusionMatch) {
            return false;
          }
        } else if (!item.itemDescription!.contains(subCategory)) {
          return false;
        }
      }
      //Price Filter
      if (maxPrice != null && item.itemPrice > maxPrice) {
        return false;
      }

      return true;
    }).toList();
  }
}
