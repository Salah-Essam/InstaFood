import 'package:insta_food/presentation/features/cart/data/models/cart_item_model.dart';

abstract class CartRepository {
  Stream<List<CartItemModel>> watchCart(String uid);
  Future<void> addOrUpdate(CartItemModel item, String uid);
  Future<void> remove(String cartItemId, String uid);
  Future<void> clear(String uid);
}
