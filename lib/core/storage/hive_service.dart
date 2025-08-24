import 'package:hive_flutter/hive_flutter.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';

const String cacheItemsKey = "cacheItems";

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
    //await Hive.openBox(cacheItemsKey);
    Hive.registerAdapter(ItemModelAdapter());
    await Hive.openBox(cacheItemsKey);
  }
}
