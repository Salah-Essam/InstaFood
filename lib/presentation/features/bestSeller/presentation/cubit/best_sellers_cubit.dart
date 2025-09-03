import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:insta_food/presentation/features/bestSeller/data/model/best_seller_item_model.dart';
import 'package:insta_food/presentation/features/bestSeller/data/repos/Best_seller_repository.dart';

part 'best_sellers_state.dart';

class BestSellersCubit extends Cubit<BestSellersState> {
  final BestSellerRepository repository;
  BestSellersCubit({required this.repository}) : super(BestSellersInitial());

  Future<void> getBestSellers() async {
    emit(BestSellersloading());
    final result = await repository.fetchItems();

    result.fold(
      // Failure case (left side)
      (failure) => emit(BestSellersError(failure.message)),
      // Success case (right side)
      (items) {
        final itemList = items.cast<BestSellerItem>();
        final featured = _getFeatured(itemList);

        emit(BestSellersLoaded(itemList, featured));
      },
    );
  }

  List<BestSellerItem> _getFeatured(
    List<BestSellerItem> allItems, {
    int count = 5,
  }) {
    if (allItems.isEmpty) return [];
    final shuffled = List<BestSellerItem>.from(allItems)..shuffle();
    return shuffled.take(count).toList();
  }
}
