part of 'leave_review_cubit.dart';

class LeaveReviewState extends Equatable {
  final int rating; // 0..5
  final String? comment;
  final bool isSubmitting;
  final bool submitted;
  final String? error;

  const LeaveReviewState({
    this.rating = 0,
    this.comment,
    this.isSubmitting = false,
    this.submitted = false,
    this.error,
  });

  LeaveReviewState copyWith({
    int? rating,
    String? comment,
    bool? isSubmitting,
    bool? submitted,
    String? error,
  }) {
    return LeaveReviewState(
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitted: submitted ?? this.submitted,
      error: error,
    );
  }

  @override
  List<Object?> get props => [rating, comment, isSubmitting, submitted, error];
}
