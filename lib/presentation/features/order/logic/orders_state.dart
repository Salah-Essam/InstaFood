part of 'orders_cubit.dart';

class OrdersState extends Equatable {
  final List<OrderModel> active;
  final List<OrderModel> completed;
  final List<OrderModel> cancelled;
  final String? error;

  const OrdersState({
    required this.active,
    required this.completed,
    required this.cancelled,
    this.error,
  });

  factory OrdersState.initial() => const OrdersState(
        active: [],
        completed: [],
        cancelled: [],
      );

  OrdersState copyWith({
    List<OrderModel>? active,
    List<OrderModel>? completed,
    List<OrderModel>? cancelled,
    String? error,
  }) {
    return OrdersState(
      active: active ?? this.active,
      completed: completed ?? this.completed,
      cancelled: cancelled ?? this.cancelled,
      error: error,
    );
  }

  @override
  List<Object?> get props => [active, completed, cancelled, error];
}
