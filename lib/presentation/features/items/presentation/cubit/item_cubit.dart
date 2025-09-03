import 'dart:async';

import 'package:flutter/material.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_food/presentation/features/filter/presentation/cubit/filter_cubit.dart';
import 'package:insta_food/presentation/features/filter/utils/filter_util.dart';
import 'package:insta_food/presentation/features/items/data/model/discounted_item.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';
import 'package:insta_food/presentation/features/items/data/repositories/item_repository.dart';

part 'item_state.dart';

class ItemCubit extends Cubit<ItemState> {
  final ItemRepository itemRepository;
  final FilterCubit filterCubit;
  ItemCubit({required this.itemRepository, required this.filterCubit})
    : super(ItemInit());
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
        final filteredlist = _applyFilters(itemList, filterCubit.state);
        emit(
          ItemLoaded(
            itemList: itemList,
            featuredItems: featuredItems,
            searchedItems: filteredlist,
            activeFilters: filterCubit.state,
          ),
        );
      },
    );
  }

  Future<void> searchItem(String name) async {
    emit(ItemLoading());
    final result = await itemRepository.fetchItem(name);
    result.fold(
      // Failure case (left side)
      (failure) => emit(ItemFailure(message: failure.message)),
      // Success case (right side)
      (items) {
        final filteredlist = _applyFilters(items, filterCubit.state);
        emit(ItemLoaded(searchedItems: filteredlist, itemList: items));
      },
    );
  }

  List<DiscountedItem> _getFeaturedItems(
    List<ItemModel> allItems, {
    int count = 5,
  }) {
    // if (allItems.isEmpty) return [];
    // final shuffled = List<ItemModel>.from(allItems)..shuffle();
    // return shuffled.take(count).toList();
    if (allItems.isEmpty) return [];

    final shuffled = List<ItemModel>.from(allItems)..shuffle();
    final featuredItems = shuffled.take(count).toList();

    return featuredItems
        .map(
          (item) => DiscountedItem(
            itemID: item.itemID,
            restaurantID: item.restaurantID,
            imageUrl: item.imageUrl,
            itemPrice: item.itemPrice,
            itemName: item.itemName,
            itemDescription: item.itemDescription,
            restaurantName: item.restaurantName,
          ),
        )
        .toList();
  }

  List<ItemModel> _applyFilters(
    List<ItemModel> items,
    FilterState filterState,
  ) {
    if (filterState is ApplyFilter) {
      return ListFilter.applyFilters(
        items: items,
        category: filterState.selectedCategory,
        subCategory: filterState.subCategory,
        maxPrice: filterState.maxPrice,
      ); // Return all items if no filters applied
    }
    return items;
  }
}
