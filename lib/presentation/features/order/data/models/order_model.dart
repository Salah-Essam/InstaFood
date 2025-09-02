import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_food/presentation/features/order/data/models/order_item_model.dart';
import 'package:insta_food/presentation/features/order/firestore/order_firestore_constants.dart';

class OrderModel {
  final String id;
  final String status; // active | completed | cancelled
  final List<OrderItemModel> items;
  final double subtotal;
  final double tax;
  final double deliveryFee;
  final double total;
  final String shippingAddress;
  final Map<String, dynamic> payment;
  final Map<String, dynamic>? delivery;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? completedAt;
  final DateTime? canceledAt;

  const OrderModel({
    required this.id,
    required this.status,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.deliveryFee,
    required this.total,
    required this.shippingAddress,
    required this.payment,
    this.delivery,
    this.createdAt,
    this.updatedAt,
    this.completedAt,
    this.canceledAt,
  });

  bool get isActive => status == 'active';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';

  factory OrderModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    final items = ((data[OrderFs.fItems] as List?) ?? [])
        .map((e) => OrderItemModel.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();

    DateTime? _toDt(dynamic v) {
      if (v is Timestamp) return v.toDate();
      if (v is DateTime) return v;
      return null;
    }

    return OrderModel(
      id: doc.id,
      status: (data[OrderFs.fStatus] ?? 'active').toString(),
      items: items,
      subtotal: (data[OrderFs.fSubtotal] is num) ? (data[OrderFs.fSubtotal] as num).toDouble() : 0.0,
      tax: (data[OrderFs.fTax] is num) ? (data[OrderFs.fTax] as num).toDouble() : 0.0,
      deliveryFee: (data[OrderFs.fDeliveryFee] is num) ? (data[OrderFs.fDeliveryFee] as num).toDouble() : 0.0,
      total: (data[OrderFs.fTotal] is num) ? (data[OrderFs.fTotal] as num).toDouble() : 0.0,
      shippingAddress: (data[OrderFs.fShippingAddress] ?? '').toString(),
      payment: Map<String, dynamic>.from((data[OrderFs.fPayment] as Map?) ?? const {}),
      delivery: data[OrderFs.fDeliveryInfo] == null
          ? null
          : Map<String, dynamic>.from(data[OrderFs.fDeliveryInfo] as Map),
      createdAt: _toDt(data[OrderFs.fCreatedAt]),
      updatedAt: _toDt(data[OrderFs.fUpdatedAt]),
      completedAt: _toDt(data[OrderFs.fCompletedAt]),
      canceledAt: _toDt(data[OrderFs.fCanceledAt]),
    );
  }
}
