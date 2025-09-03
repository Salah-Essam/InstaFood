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
      'tandoor',
    ],
  ),
  meals(
    name: AppStrings.meals,
    icon: AppAssets.meals,
    keywords: ['curry', 'biryani', 'grilled', 'cooked', 'seafood'],
  ),
  vegan(
    name: AppStrings.vegan,
    icon: AppAssets.vegan,
    keywords: ['mango', 'vegetables', 'pizza', 'green'],
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
      'Prawn',
      'lamb',
    ],
  ),
  desserts(
    name: AppStrings.desserts,
    icon: AppAssets.desserts,
    keywords: [
      'sweet',
      'syrup',
      'sugar',
      'pudding',
      'vermicelli',
      'mango',
      'fruits',
    ],
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
  static FoodCategory fromString(String value) {
    return FoodCategory.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => FoodCategory.meals,
    );
  }
}
