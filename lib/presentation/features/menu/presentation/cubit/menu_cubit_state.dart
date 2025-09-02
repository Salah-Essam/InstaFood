import 'package:insta_food/presentation/features/items/data/model/item_model.dart';
import 'package:insta_food/presentation/features/Restaurants/data/model/restaurant_model.dart';

abstract class MenuState {}

class MenuInitial extends MenuState {}
class MenuLoading extends MenuState {}
class MenuError extends MenuState { final String message; MenuError(this.message); }
class MenuLoaded extends MenuState {
  final Restaurant? restaurant;
  final List<ItemModel> allItems; 
  final List<ItemModel> visibleItems; 
  final String? activeCategory; 
  final String? activePriceFilter; 
  final bool isFilterDropdownOpen;
  MenuLoaded({
    required this.restaurant, 
    required this.allItems, 
    required this.visibleItems, 
    required this.activeCategory,
    this.activePriceFilter,
    this.isFilterDropdownOpen = false,
  });
  
  MenuLoaded copyWith({
    Restaurant? restaurant,
    List<ItemModel>? allItems,
    List<ItemModel>? visibleItems,
    String? activeCategory,
    String? activePriceFilter,
    bool? isFilterDropdownOpen,
    bool clearCategory = false,
    bool clearPriceFilter = false,
  }) => MenuLoaded(
    restaurant: restaurant ?? this.restaurant,
    allItems: allItems ?? this.allItems,
    visibleItems: visibleItems ?? this.visibleItems,
    activeCategory: clearCategory ? null : (activeCategory ?? this.activeCategory),
    activePriceFilter: clearPriceFilter ? null : (activePriceFilter ?? this.activePriceFilter),
    isFilterDropdownOpen: isFilterDropdownOpen ?? this.isFilterDropdownOpen,
  );
}