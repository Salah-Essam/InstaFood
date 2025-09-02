import 'package:hive_flutter/hive_flutter.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';
import 'package:insta_food/presentation/features/Restaurants/data/model/restaurant_model.dart';

const String cacheItemsKey = "cacheItems";
const String cacheRestaurantsKey = "cacheRestaurants";
const String cacheFavoritesKey = "cacheFavorites";

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
  Hive.registerAdapter(ItemModelAdapter());
  Hive.registerAdapter(RestaurantAdapter());

    // Open boxes
  await Hive.openBox<ItemModel>(cacheItemsKey);
  await Hive.openBox<Restaurant>(cacheRestaurantsKey);
  await Hive.openBox<ItemModel>(cacheFavoritesKey);

  }
}
