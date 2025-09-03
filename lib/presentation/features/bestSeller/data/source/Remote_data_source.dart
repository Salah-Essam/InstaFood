import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_food/core/errors/failures.dart';
import 'package:insta_food/presentation/features/bestSeller/data/model/best_seller_item_model.dart';

abstract class BestSellersRemoteDataSource {
  Future<dynamic> fetchBestSellers();
}

class BestSellersRemoteDataSourceImpl implements BestSellersRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final instance = FirebaseFirestore.instance;
  BestSellersRemoteDataSourceImpl({required this.firebaseFirestore});

  @override
  Future<List<BestSellerItem>> fetchBestSellers() async {
    try {
      final snapshot = await instance.collection("Best Sellers").get();
      return snapshot.docs
          .map((doc) => BestSellerItem.fromQuerySnapshot(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerFailure(e.message ?? 'Server error');
    }
  }
}
