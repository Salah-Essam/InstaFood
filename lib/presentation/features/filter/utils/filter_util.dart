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
        dynamic hasExclusionMatch;
        dynamic hasMatchingSubCategory;
        // Check if item description contains ANY of the category's keywords (subcategories)
        if (subCategory == null) {
          hasMatchingSubCategory = category.keywords.any(
            (subCategory) =>
                item.itemDescription?.toLowerCase().contains(
                  subCategory.toLowerCase(),
                ) ??
                false,
          );

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
        } else {
          // Check for SPECIFIC subcategory match
          hasMatchingSubCategory =
              item.itemDescription?.toLowerCase().contains(
                subCategory.toLowerCase(),
              ) ??
              false;

          // Check for ANY exclusion keyword match
          hasExclusionMatch = category.exclusionKeywords.any(
            (keyword) =>
                item.itemDescription?.toLowerCase().contains(
                  keyword.toLowerCase(),
                ) ??
                false,
          );

          // Use your exact structure: return false if doesn't match subcategory OR has exclusion
          if (!hasMatchingSubCategory || hasExclusionMatch) {
            return false;
          }
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
