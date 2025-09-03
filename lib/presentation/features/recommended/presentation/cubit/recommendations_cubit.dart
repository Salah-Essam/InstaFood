import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:insta_food/presentation/features/bestSeller/presentation/cubit/best_sellers_cubit.dart';
import 'package:insta_food/presentation/features/favorites/logic/favorites_cubit.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';

part 'recommendations_state.dart';

class RecommendationsCubit extends Cubit<RecommendationsState> {
  final BestSellersCubit bestSellers;
  final FavoritesCubit favorites;
  RecommendationsCubit({required this.bestSellers, required this.favorites})
    : super(RecommendationsInitial()) {
    // Listen to changes in both cubits
    bestSellers.stream.listen((_) => loadRecommendations());
    favorites.stream.listen((_) => loadRecommendations());

    // Initial load
    loadRecommendations();
  }

  void loadRecommendations() {
    emit(RecommendationsLoading());
    final bestSellersState = bestSellers.state;
    final favoritesState = favorites.state;
    if (bestSellersState is BestSellersInitial) {
      bestSellers.getBestSellers();
      emit(RecommendationsLoading());
      return;
    }
    try {
      if (bestSellersState is BestSellersLoaded) {
        // Combine and remove duplicates
        final combinedList = [
          ...bestSellersState.bestSellers,
          ...favoritesState.items,
        ];
        final uniqueItems = combinedList
            .fold<Map<String, ItemModel>>({}, (map, currentItem) {
              map[currentItem.itemID.toString()] = currentItem;
              return map;
            })
            .values
            .toList();

        // Select 2 featured items (highest rated)
        final featuredItems = List.from(uniqueItems)..shuffle();
        final selectedFeatured = featuredItems.take(2).toList();

        // Select 1 thumbnail item (most expensive)
        final thumbnailItem = uniqueItems.isNotEmpty
            ? uniqueItems.reduce((a, b) => a.itemPrice > b.itemPrice ? a : b)
            : null;
        // Remove thumbnail item from uniqueItems if it exists
        if (thumbnailItem != null) {
          uniqueItems.remove(thumbnailItem);
        }
        emit(
          RecommendationsLoaded(uniqueItems, selectedFeatured, thumbnailItem),
        );
      } else {}
    } catch (e) {
      emit(RecommendationsFailure('Failed to load recommendations: $e'));
    }
  }
}
