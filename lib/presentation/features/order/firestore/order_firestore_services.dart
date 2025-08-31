import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_food/presentation/features/order/firestore/order_firestore_constants.dart';

class OrderFirestoreService {
  final FirebaseFirestore _db;
  OrderFirestoreService({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _userOrders(String uid) =>
      _db.collection(OrderFs.users).doc(uid).collection(OrderFs.subOrders);

  // Create an active order from a payload (cart snapshot + totals)
  Future<String> createActiveOrder({
    required String uid,
    required Map<String, dynamic> order,
  }) async {
    order[OrderFs.fStatus] = 'active';
    order[OrderFs.fCreatedAt] = FieldValue.serverTimestamp();
    order[OrderFs.fUpdatedAt] = FieldValue.serverTimestamp();
    final ref = await _userOrders(uid).add(order);
    return ref.id;
  }

  // Update order status to completed (with payment success)
  Future<void> markOrderCompleted({
    required String uid,
    required String orderId,
    String? transactionId,
  }) async {
    await _userOrders(uid).doc(orderId).update({
      OrderFs.fStatus: 'completed',
      '${OrderFs.fPayment}.status': 'paid',
      if (transactionId != null) '${OrderFs.fPayment}.transactionId': transactionId,
      OrderFs.fCompletedAt: FieldValue.serverTimestamp(),
      OrderFs.fUpdatedAt: FieldValue.serverTimestamp(),
    });
  }

  // Cancel active order
  Future<void> cancelOrder({
    required String uid,
    required String orderId,
    String? reason,
  }) async {
    await _userOrders(uid).doc(orderId).update({
      OrderFs.fStatus: 'cancelled',
      OrderFs.fCanceledAt: FieldValue.serverTimestamp(),
      OrderFs.fUpdatedAt: FieldValue.serverTimestamp(),
      if (reason != null) 'cancelReason': reason,
    });
  }

  // Add review under a completed order for an item
  Future<void> addReview({
    required String uid,
    required String orderId,
    required String itemId,
    required int rating,
    String? comment,
  }) async {
    final reviewRef = _userOrders(uid)
        .doc(orderId)
        .collection(OrderFs.subReviews)
        .doc(itemId);

    await reviewRef.set({
      OrderFs.fRating: rating,
      if (comment != null && comment.isNotEmpty) OrderFs.fComment: comment,
      OrderFs.fReviewCreatedAt: FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getOrder({
    required String uid,
    required String orderId,
  }) {
    return _userOrders(uid).doc(orderId).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getOrdersByStatus({
    required String uid,
    required String status, // active | completed | cancelled
  }) {
    return _userOrders(uid)
        .where(OrderFs.fStatus, isEqualTo: status)
        .orderBy(OrderFs.fCreatedAt, descending: true)
        .get();
  }
}
