import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_food/presentation/features/PaymentMethods/data/models/payment_model.dart';
import 'package:insta_food/presentation/features/PaymentMethods/data/repositories/payment_repo.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial()) {
    loadPayments();
  }

  void loadPayments() {
    final payments = PaymentRepository.getPaymentRepo();
    emit(PaymentLoaded(payment: payments, selectedId: payments.first.id));
  }

  void selectPayment(int id) {
    if (state is PaymentLoaded) {
      final currentState = state as PaymentLoaded;
      emit(currentState.copyWith(selectedId: id));
    }
  }
}
