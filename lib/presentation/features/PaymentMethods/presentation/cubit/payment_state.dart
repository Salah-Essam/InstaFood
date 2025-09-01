part of 'payment_cubit.dart';

abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoaded extends PaymentState {
  final List<PaymentModel> payment;
  final int selectedId;

  PaymentLoaded({required this.payment, required this.selectedId});

  PaymentLoaded copyWith({List<PaymentModel>? payment, int? selectedId}) {
    return PaymentLoaded(
      payment: payment ?? this.payment,
      selectedId: selectedId ?? this.selectedId,
    );
  }
}
