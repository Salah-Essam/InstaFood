import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_food/presentation/features/cart/firestore/cart_firestore_constants.dart';

class CartFirestoreService {
	final FirebaseFirestore _db;
	CartFirestoreService({FirebaseFirestore? firestore})
			: _db = firestore ?? FirebaseFirestore.instance;

	CollectionReference<Map<String, dynamic>> _userCart(String uid) =>
			_db.collection(CartFs.users).doc(uid).collection(CartFs.subCart);

	Future<void> upsertCartItem({
		required String uid,
		required String cartItemId,
		required Map<String, dynamic> data,
	}) async {
		data[CartFs.fCartItemId] = cartItemId;
		data[CartFs.fUpdatedAt] = FieldValue.serverTimestamp();
		data[CartFs.fAddedAt] ??= FieldValue.serverTimestamp();
		await _userCart(uid).doc(cartItemId).set(data, SetOptions(merge: true));
	}

	Future<void> removeCartItem({
		required String uid,
		required String cartItemId,
	}) async {
		await _userCart(uid).doc(cartItemId).delete();
	}

	Future<void> clearCart({required String uid}) async {
		final batch = _db.batch();
		final snap = await _userCart(uid).get();
		for (final d in snap.docs) {
			batch.delete(d.reference);
		}
		await batch.commit();
	}

	Future<QuerySnapshot<Map<String, dynamic>>> getCart({required String uid}) {
		return _userCart(uid).orderBy(CartFs.fAddedAt, descending: false).get();
	}

	/// Real-time updates to the user's cart collection
	Stream<QuerySnapshot<Map<String, dynamic>>> userCartStream(String uid) {
		return _userCart(uid)
			.orderBy(CartFs.fAddedAt, descending: false)
			.snapshots();
	}
}

