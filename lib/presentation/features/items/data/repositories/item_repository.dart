import 'package:dartz/dartz.dart';
import 'package:insta_food/core/errors/failures.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';

abstract class ItemRepository {
  Future<Either<Failure, List<ItemModel>>> fetchItems();
  Future<Either<Failure, List<ItemModel>>> fetchItem(String name);
}
