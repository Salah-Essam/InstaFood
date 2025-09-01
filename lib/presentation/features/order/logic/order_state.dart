import 'package:equatable/equatable.dart';

abstract class OrderState extends Equatable {
	@override
	List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderPlacing extends OrderState {}

class OrderPlaced extends OrderState {
	final String orderId;
	OrderPlaced(this.orderId);
	@override
	List<Object?> get props => [orderId];
}

class OrderError extends OrderState {
	final String message;
	OrderError(this.message);
	@override
	List<Object?> get props => [message];
}

