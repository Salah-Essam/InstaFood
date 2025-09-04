part of 'recommendations_cubit.dart';

sealed class RecommendationsState extends Equatable {
  const RecommendationsState();

  @override
  List<Object> get props => [];
}

final class RecommendationsInitial extends RecommendationsState {}

final class RecommendationsLoading extends RecommendationsState {}

final class RecommendationsFailure extends RecommendationsState {
  final String message;

  const RecommendationsFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class RecommendationsLoaded extends RecommendationsState {
  final List<dynamic> recommendations;
  final List<dynamic> featuredItems;
  final dynamic thumbnailItem;
  const RecommendationsLoaded(
    this.recommendations,
    this.featuredItems,
    this.thumbnailItem,
  );

  @override
  List<Object> get props => [recommendations, featuredItems, thumbnailItem];
}
