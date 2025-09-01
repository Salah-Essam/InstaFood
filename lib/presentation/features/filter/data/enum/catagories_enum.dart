import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/core/utils/app_strings.dart';

enum FoodCategory {
  snacks(
    name: AppStrings.snacks,
    icon: AppAssets.snacks,
    keywords: [
      'fried',
      'fritter',
      'in a bun',
      'wrapped',
      'street food',
      'skewers',
    ],
  ),
  meals(
    name: AppStrings.meals,
    icon: AppAssets.meals,
    keywords: ['curry', 'biryani', 'grilled', 'cooked', 'rice', 'naan'],
  ),
  vegan(
    name: AppStrings.vegan,
    icon: AppAssets.vegan,
    keywords: ['coconut milk', 'vegetables', 'pizza'],
    exclusionKeywords: [
      'meat',
      'chicken',
      'mutton',
      'fish',
      'prawn',
      'cream',
      'butter',
      'yogurt',
      'milk',
    ],
  ),
  desserts(
    name: AppStrings.desserts,
    icon: AppAssets.desserts,
    keywords: ['sweet', 'syrup', 'sugar', 'pudding', 'vermicelli'],
    exclusionKeywords: ["sweet churma", "drink"],
  ),
  drinks(
    name: AppStrings.drinks,
    icon: AppAssets.drinks,
    keywords: ['drink', 'brewed', 'coffee', 'beer'],
    exclusionKeywords: ['coffee-soaked'],
  );

  final String name;
  final String icon;
  final List<String> keywords;
  final List<String> exclusionKeywords;

  const FoodCategory({
    required this.name,
    required this.icon,
    required this.keywords,
    this.exclusionKeywords = const [],
  });
}
