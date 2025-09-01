part of "item_cubit.dart";

@immutable
sealed class ItemState {}

class ItemInit extends ItemState {}

class ItemLoading extends ItemState {}

class ItemLoaded extends ItemState {
  final List<ItemModel> itemList;
  final List<ItemModel>? featuredItems;
  final List<ItemModel> searchedItems;
  ItemLoaded({
    required this.itemList,
    this.featuredItems,
    required this.searchedItems,
  });
}

final class ItemFailure extends ItemState {
  final String message;
  ItemFailure({required this.message});
}
