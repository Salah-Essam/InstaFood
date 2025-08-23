import 'package:dartz/dartz.dart';
import 'package:insta_food/core/errors/failures.dart';

abstract class ItemRepository {
  Future<Either<Failure, List<dynamic>>> fetchItems();
  Future<Either<Failure, List<dynamic>>> fetchItem(String name);
}
