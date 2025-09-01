import 'package:equatable/equatable.dart';
import 'package:insta_food/presentation/features/cart/data/models/cart_item_model.dart';

abstract class CartState extends Equatable {
	@override
	List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
	final List<CartItemModel> items;
	final double subtotal;
	final double tax;
	final double delivery;
	final double total;
	// Tax here is an absolute value (not percentage). If you want percentage, compute it before passing.
	CartLoaded({required this.items, this.tax = 0, this.delivery = 0})
			: subtotal = items.fold(0.0, (p, e) => p + e.totalPrice),
				total = items.fold(0.0, (p, e) => p + e.totalPrice) + tax + delivery;

	@override
	List<Object?> get props => [items, subtotal, tax, delivery, total];
}

class CartError extends CartState {
	final String message;
	CartError(this.message);
	@override
	List<Object?> get props => [message];
}

class CartActionBlocked extends CartState {
	final String reason; // e.g., not logged in
	CartActionBlocked(this.reason);
	@override
	List<Object?> get props => [reason];
}
