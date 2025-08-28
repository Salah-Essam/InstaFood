import 'package:flutter/material.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';
import 'package:insta_food/presentation/features/items/data/repositories/item_repository.dart';

part 'item_state.dart';

class ItemCubit extends Cubit<ItemState> {
  final ItemRepository itemRepository;

  ItemCubit({required this.itemRepository}) : super(ItemInit());
  Future<void> getallItems() async {
    emit(ItemLoading());
    final result = await itemRepository.fetchItems();

    result.fold(
      // Failure case (left side)
      (failure) => emit(ItemFailure(message: failure.message)),
      // Success case (right side)
      (items) {
        final itemList = items.cast<ItemModel>();
        final featuredItems = _getFeaturedItems(itemList, count: 5);
        emit(
          ItemLoaded(
            itemList: itemList,
            featuredItems: featuredItems,
            searchedItems: itemList,
          ),
        );
      },
    );
  }

  Future<void> searchItem(String name) async {
    if (name.isEmpty) {
      // If search is empty, show all items
      if (state is ItemLoaded) {
        final currentState = state as ItemLoaded;
        emit(
          ItemLoaded(
            itemList: currentState.itemList,
            searchedItems: currentState.itemList,
          ),
        );
      } else {
        await getallItems();
      }
      return;
    }
    emit(ItemLoading());
    final result = await itemRepository.fetchItem(name);
    result.fold(
      // Failure case (left side)
      (failure) => emit(ItemFailure(message: failure.message)),
      // Success case (right side)
      (items) => emit(ItemLoaded(searchedItems: items, itemList: items)),
    );
  }

  List<ItemModel> _getFeaturedItems(List<ItemModel> allItems, {int count = 5}) {
    if (allItems.isEmpty) return [];
    final shuffled = List<ItemModel>.from(allItems)..shuffle();
    return shuffled.take(count).toList();
  }
}
