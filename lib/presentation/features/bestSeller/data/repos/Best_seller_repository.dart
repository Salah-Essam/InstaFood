import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:insta_food/core/errors/failures.dart';
import 'package:insta_food/presentation/features/bestSeller/data/model/best_seller_item_model.dart';
import 'package:insta_food/presentation/features/bestSeller/data/source/Remote_data_source.dart';

abstract class BestSellerRepository {
  Future<Either<Failure, List<BestSellerItem>>> fetchItems();
}

class BestSellersRepoImpl implements BestSellerRepository {
  final BestSellersRemoteDataSource remoteDataSource;

  BestSellersRepoImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, List<BestSellerItem>>> fetchItems() async {
    try {
      final remoteData = await remoteDataSource.fetchBestSellers();
      log(remoteData.runtimeType.toString());
      return Right(remoteData);
    } on ServerFailure catch (e) {
      return Left(e);
    }
  }
}
