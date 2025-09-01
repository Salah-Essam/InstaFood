import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:insta_food/presentation/features/filter/data/enum/catagories_enum.dart';

part 'filter_state.dart';

class FilterCubit extends Cubit<FilterState> {
  FilterCubit() : super(FilterInitial());
  void setCategoryFilter(FoodCategory category) {
    final currentState = state;

    if (currentState is SetFilter) {
      emit(currentState.copyWith(selectedCategory: category));
    } else {
      emit(SetFilter(selectedCategory: category));
    }
  }

  void setRatingFilter(int rating) {
    final currentState = state;

    if (currentState is SetFilter) {
      // Toggle logic: if same rating clicked, deselect it
      if (currentState.minRating == rating) {
        emit(currentState.copyWith(minRating: null)); // Toggle off
      } else {
        emit(currentState.copyWith(minRating: rating)); // Toggle on
      }
    } else {
      emit(SetFilter(minRating: rating)); // First selection
    }
  }

  void toggleCategory(FoodCategory category) {
    final currentState = state;

    if (currentState is SetFilter) {
      print(
        'VALIDATION: Current selected index: ${currentState.selectedCategory?.index}',
      );
      print('VALIDATION: Clicked category index: ${category.index}');
      // If clicking the already selected category, deselect it
      if (currentState.selectedCategory == category) {
        emit(SetFilter(selectedCategory: null));
      } else {
        // Select the new category (automatically deselects previous)
        emit(SetFilter(selectedCategory: category));
      }
      print(currentState.selectedCategory?.name ?? "none");
    } else {
      // If no filter state exists, create one with this category
      emit(SetFilter(selectedCategory: category));
    }
  }
}
