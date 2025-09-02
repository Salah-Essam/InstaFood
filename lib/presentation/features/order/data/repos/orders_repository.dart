import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_food/presentation/features/order/data/models/order_model.dart';

abstract class OrdersRepository {
  Stream<List<OrderModel>> watchAll(String uid);
  Stream<List<OrderModel>> watchByStatus(String uid, String status);
  Future<void> cancel(String uid, String orderId, {String? reason});
  Future<void> addReview({
    required String uid,
    required String orderId,
    required String itemId,
    required int rating,
    String? comment,
  });
  Future<bool> hasReview({
    required String uid,
    required String orderId,
    required String itemId,
  });
}

class OrdersRepositoryFs implements OrdersRepository {
  final FirebaseFirestore db;
  OrdersRepositoryFs(this.db);

  CollectionReference<Map<String, dynamic>> _ordersCol(String uid) =>
      db.collection('users').doc(uid).collection('orders');

  @override
  Stream<List<OrderModel>> watchAll(String uid) {
    return _ordersCol(uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(OrderModel.fromDoc).toList());
  }

  @override
  Stream<List<OrderModel>> watchByStatus(String uid, String status) {
  return _ordersCol(uid)
    .where('status', isEqualTo: status)
    .snapshots()
    .map((snap) => snap.docs.map(OrderModel.fromDoc).toList());
  }

  @override
  Future<void> cancel(String uid, String orderId, {String? reason}) async {
    await _ordersCol(uid).doc(orderId).update({
      'status': 'cancelled',
      'canceledAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      if (reason != null) 'cancelReason': reason,
    });
  }

  @override
  Future<void> addReview({
    required String uid,
    required String orderId,
    required String itemId,
    required int rating,
    String? comment,
  }) async {
  final reviews = _ordersCol(uid).doc(orderId).collection('reviews');
  final trimmed = itemId.trim();
  final ref = trimmed.isEmpty ? reviews.doc() : reviews.doc(trimmed);
  await ref.set({
      'rating': rating,
      if (comment != null && comment.isNotEmpty) 'comment': comment,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Future<bool> hasReview({
    required String uid,
    required String orderId,
    required String itemId,
  }) async {
    final doc = await _ordersCol(uid)
        .doc(orderId)
        .collection('reviews')
        .doc(itemId.trim())
        .get();
    return doc.exists;
  }
}
