import 'package:hive_flutter/hive_flutter.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';

const String cacheItemsKey = "cacheItems";

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(ItemModelAdapter());

    // Open boxes
    await Hive.openBox(cacheItemsKey);
  }
}
