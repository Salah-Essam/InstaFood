import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:insta_food/core/connection/networkInfo.dart';
import 'package:insta_food/core/errors/failures.dart';
import 'package:insta_food/presentation/features/items/data/data%20sources/local_data_source.dart';
import 'package:insta_food/presentation/features/items/data/data%20sources/remote_data_source.dart';
import 'package:insta_food/presentation/features/items/data/repositories/item_repository.dart';

class ItemRepoImpl implements ItemRepository {
  final ItemsRemoteDataSource remoteDataSource;
  final ItemsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ItemRepoImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, List<dynamic>>> fetchItems() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.fetchItems();
        log(remoteData.runtimeType.toString());
        await localDataSource.cacheItems(remoteData);
        return Right(remoteData);
      } on ServerFailure catch (e) {
        return Left(e);
      }
    } else {
      final cachedData = await localDataSource.getCachedItems();
      if (cachedData != null) {
        return Right(cachedData);
      }
      return Left(CacheFailure("No internet & no cached data available."));
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> fetchItem(String name) async {
    try {
      final remoteData = await remoteDataSource.itemSearch(name);
      return Right(remoteData);
    } on ServerFailure catch (e) {
      return Left(e);
    }
  }
}
