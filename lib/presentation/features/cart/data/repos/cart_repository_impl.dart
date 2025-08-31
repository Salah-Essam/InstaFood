import 'package:insta_food/presentation/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:insta_food/presentation/features/cart/data/models/cart_item_model.dart';
import 'package:insta_food/presentation/features/cart/data/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remote;
  CartRepositoryImpl({required this.remote});

  @override
  Future<void> addOrUpdate(CartItemModel item, String uid) =>
      remote.upsert(item, uid);

  @override
  Future<void> clear(String uid) => remote.clear(uid);

  @override
  Future<void> remove(String cartItemId, String uid) =>
      remote.remove(cartItemId, uid);

  @override
  Stream<List<CartItemModel>> watchCart(String uid) => remote.watchCart(uid);
}
