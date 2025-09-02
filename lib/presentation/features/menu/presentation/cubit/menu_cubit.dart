import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_food/presentation/features/menu/presentation/cubit/menu_cubit_state.dart';
import 'package:insta_food/presentation/features/menu/data/Repository/menu_repository.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';
import 'package:insta_food/presentation/features/Restaurants/data/model/restaurant_model.dart';
import 'package:insta_food/core/storage/shared_prefrences/shared_prefs_service.dart';
import 'package:insta_food/core/constants/menu_constants.dart';

class MenuCubit extends Cubit<MenuState> {
  final MenuRepository repository;
  SharedPrefsService? _prefs;
  MenuCubit({required this.repository}) : super(MenuInitial());

  static const _imageCachePrefix = 'restaurant_menu_images_';

  Future<void> load(Restaurant? restaurant) async {
    emit(MenuLoading());
    try {
      _prefs = await SharedPrefsService.getInstance();
      if (restaurant == null) {
        emit(MenuError('Restaurant not provided'));
        return;
      }
      final result = await repository.getMenu(restaurant.restaurantID);
      result.fold(
        (failure) => emit(MenuError(failure.message)),
        (items) async {
          await _cacheImageUrls(restaurant, items);
          emit(MenuLoaded(
            restaurant: restaurant, 
            allItems: items, 
            visibleItems: items, 
            activeCategory: null,
            activePriceFilter: null,
            isFilterDropdownOpen: false,
          ));
        });
    } catch (e) {
      emit(MenuError('Failed to load menu'));
    }
  }

  Future<void> _cacheImageUrls(Restaurant? r, List<ItemModel> items) async {
    if (_prefs == null || r == null) return;
    final key = '$_imageCachePrefix${r.restaurantID}';
    final urls = items.map((e) => e.imageUrl).where((u) => u.isNotEmpty).toList();
    await _prefs!.setValue(key, urls);
  }

  void filterByCategory(String? category) {
    final current = state;
    if (current is! MenuLoaded) return;
    if (category == null || category == MenuConstants.defaultCategory) {
      emit(current.copyWith(visibleItems: current.allItems, clearCategory: true));
      return;
    }
    final filtered = current.allItems.where((i) => _deriveCategory(i) == category).toList();
    emit(current.copyWith(visibleItems: filtered, activeCategory: category));
  }

  Future<void> filterByPrice(String sortOption) async {
    final current = state;
    if (current is! MenuLoaded || current.restaurant == null) return;
    
    emit(current.copyWith(isFilterDropdownOpen: false));
    
    if (sortOption == MenuConstants.defaultPriceFilter) {
      // Reset to current category filter or all items
      if (current.activeCategory == null || current.activeCategory == MenuConstants.defaultCategory) {
        emit(current.copyWith(visibleItems: current.allItems, clearPriceFilter: true));
      } else {
        final filtered = current.allItems.where((i) => _deriveCategory(i) == current.activeCategory).toList();
        emit(current.copyWith(visibleItems: filtered, clearPriceFilter: true));
      }
      return;
    }
    
    // Fetch from API with price sorting
    emit(MenuLoading());
    try {
      final sortByPrice = sortOption == 'Ascending' ? 'asc' : 'desc';
      final result = await repository.getMenu(current.restaurant!.restaurantID, sortByPrice: sortByPrice);
      
      result.fold(
        (failure) => emit(MenuError(failure.message)),
        (items) async {
          await _cacheImageUrls(current.restaurant, items);
          
          // Apply category filter if active
          List<ItemModel> visibleItems = items;
          if (current.activeCategory != null && current.activeCategory != MenuConstants.defaultCategory) {
            visibleItems = items.where((i) => _deriveCategory(i) == current.activeCategory).toList();
          }
          
          emit(MenuLoaded(
            restaurant: current.restaurant,
            allItems: items,
            visibleItems: visibleItems,
            activeCategory: current.activeCategory,
            activePriceFilter: sortOption,
            isFilterDropdownOpen: false,
          ));
        },
      );
    } catch (e) {
      emit(MenuError('Failed to apply price filter'));
    }
  }
  
  void toggleFilterDropdown() {
    final current = state;
    if (current is! MenuLoaded) return;
    emit(current.copyWith(isFilterDropdownOpen: !current.isFilterDropdownOpen));
  }

  // Derive category from name heuristically (since ItemModel lacks explicit category field)
  String _deriveCategory(ItemModel item) {
    final name = item.itemName.toLowerCase();
    if (name.contains('drink') || name.contains('juice') || name.contains('coffee') || name.contains('tea') || name.contains('cola') || name.contains('water')) return 'Drinks';
    if (name.contains('snack') || name.contains('fries') || name.contains('nacho') || name.contains('chip') || name.contains('popcorn')) return 'Snacks';
    if (name.contains('vegan') || name.contains('quinoa') || name.contains('avocado') || name.contains('salad') || name.contains('vegetable')) return 'Vegan';
    if (name.contains('cake') || name.contains('dessert') || name.contains('ice cream') || name.contains('cookie') || name.contains('chocolate')) return 'Dessert';
    return 'Meal';
  }
}