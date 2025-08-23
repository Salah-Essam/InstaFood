part of "item_cubit.dart";

@immutable
sealed class ItemState {}

class ItemInit extends ItemState {}

class ItemLoading extends ItemState {}

class ItemLoaded extends ItemState {
  final dynamic itemList;
  final String? sortOrder;
  final String? searchQuery;
  ItemLoaded({required this.itemList, this.sortOrder, this.searchQuery});
}

final class ItemFailure extends ItemState {
  final String message;
  ItemFailure({required this.message});
}
