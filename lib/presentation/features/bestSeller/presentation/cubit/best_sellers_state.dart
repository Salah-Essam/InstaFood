part of 'best_sellers_cubit.dart';

sealed class BestSellersState extends Equatable {
  const BestSellersState();

  @override
  List<Object> get props => [];
}

final class BestSellersInitial extends BestSellersState {}

final class BestSellersloading extends BestSellersState {}

class BestSellersLoaded extends BestSellersState {
  final List<BestSellerItem> bestSellers;
  final List<BestSellerItem> featuredBestSellers;
  const BestSellersLoaded(this.bestSellers, this.featuredBestSellers);

  @override
  List<Object> get props => [bestSellers, featuredBestSellers];
}

class BestSellersError extends BestSellersState {
  final String message;

  const BestSellersError(this.message);

  @override
  List<Object> get props => [message];
}
