import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_state.dart';
import 'package:insta_food/presentation/features/order/data/repos/orders_repository.dart';

part 'leave_review_state.dart';

class LeaveReviewCubit extends Cubit<LeaveReviewState> {
  LeaveReviewCubit({required this.repo, required this.auth}) : super(const LeaveReviewState());

  final OrdersRepository repo;
  final AuthCubit auth;

  void setRating(int rating) => emit(state.copyWith(rating: rating.clamp(0, 5)));
  void setComment(String comment) => emit(state.copyWith(comment: comment));

  Future<void> submit({required String orderId, required String itemId}) async {
    if (state.rating <= 0) {
      emit(state.copyWith(error: 'rating_required'));
      return;
    }
    final a = auth.state;
    if (a is! Authenticated || (a.user.id ?? '').isEmpty) {
      emit(state.copyWith(error: 'login_required'));
      return;
    }
    emit(state.copyWith(isSubmitting: true, error: null));
    try {
      await repo.addReview(
        uid: a.user.id!,
        orderId: orderId,
        itemId: itemId,
        rating: state.rating,
        comment: state.comment?.trim().isEmpty ?? true ? null : state.comment?.trim(),
      );
      emit(state.copyWith(isSubmitting: false, submitted: true));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, error: 'submit_failed'));
    }
  }
}
