import 'package:insta_food/presentation/features/cart/data/models/cart_item_model.dart';
import 'package:insta_food/presentation/features/cart/firestore/cart_firestore_services.dart';

abstract class CartRemoteDataSource {
  Stream<List<CartItemModel>> watchCart(String uid);
  Future<void> upsert(CartItemModel item, String uid);
  Future<void> remove(String cartItemId, String uid);
  Future<void> clear(String uid);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final CartFirestoreService service;
  CartRemoteDataSourceImpl({required this.service});

  @override
  Stream<List<CartItemModel>> watchCart(String uid) {
    return service
        .userCartStream(uid)
        .map((qs) =>
            qs.docs.map((d) => CartItemModel.fromFirestore(d.data())).toList());
  }

  @override
  Future<void> upsert(CartItemModel item, String uid) async {
    await service.upsertCartItem(
      uid: uid,
      cartItemId: item.cartItemId,
      data: item.toFirestore(),
    );
  }

  @override
  Future<void> remove(String cartItemId, String uid) =>
      service.removeCartItem(uid: uid, cartItemId: cartItemId);

  @override
  Future<void> clear(String uid) => service.clearCart(uid: uid);
}
