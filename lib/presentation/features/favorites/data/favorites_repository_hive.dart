import 'package:hive/hive.dart';
import 'package:insta_food/presentation/features/favorites/domain/favorites_repository.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';

/// Hive-backed favorites per session (per-user by uid key namespace)
class FavoritesRepositoryHive implements FavoritesRepository {
  FavoritesRepositoryHive({required this.box, required this.uidProvider});

  final Box<ItemModel> box;
  final String Function() uidProvider; // returns current uid or 'guest'

  String _ns() {
    final uid = uidProvider();
    return (uid.isEmpty) ? 'guest' : uid;
  }

  String _key(int itemId) => '${_ns()}::$itemId';

  @override
  Map<int, ItemModel> get favoritesMap {
    final ns = '${_ns()}::';
    final map = <int, ItemModel>{};
    for (final k in box.keys) {
      if (k is String && k.startsWith(ns)) {
        final v = box.get(k);
        if (v != null) {
          final idStr = k.substring(ns.length);
          final id = int.tryParse(idStr);
          if (id != null) map[id] = v;
        }
      }
    }
    return map;
  }

  @override
  List<ItemModel> get favorites => favoritesMap.values.toList(growable: false);

  @override
  bool isFavorite(int itemId) => box.containsKey(_key(itemId));

  @override
  void add(ItemModel item) => box.put(_key(item.itemID), item);

  @override
  void remove(int itemId) => box.delete(_key(itemId));

  @override
  void toggle(ItemModel item) {
    final key = _key(item.itemID);
    if (box.containsKey(key)) {
      box.delete(key);
    } else {
      box.put(key, item);
    }
  }

  @override
  void clear() {
    final ns = '${_ns()}::';
    final keysToDelete = <String>[];
    for (final k in box.keys) {
      if (k is String && k.startsWith(ns)) keysToDelete.add(k);
    }
    box.deleteAll(keysToDelete);
  }
}
