import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:insta_food/presentation/features/filter/data/enum/catagories_enum.dart';
import 'package:flutter/material.dart';

part 'filter_state.dart';

class FilterCubit extends Cubit<FilterState> {
  FilterCubit() : super(FilterInitial());

  void setCategoryFilter(FoodCategory? category) {
    final currentState = state;

    if (currentState is SetCatagoryFilter) {
      if (currentState.selectedCategory == category) {
        emit(currentState.copyWith(selectedCategory: null));
      } else {
        emit(currentState.copyWith(selectedCategory: category));
      }
    } else {
      emit(SetCatagoryFilter(selectedCategory: category));
    }
  }

  void setRatingFilter(int? rating) {
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
      // If clicking the already selected category, deselect it
      if (currentState.selectedCategory == category) {
        emit(currentState.copyWith(selectedCategory: null));
      } else {
        // Select the new category (automatically deselects previous)
        emit(currentState.copyWith(selectedCategory: category));
      }
    } else {
      // If no filter state exists, create one with this category
      emit(SetFilter(selectedCategory: category));
    }
  }

  void toggleSubCategory(String category) {
    final currentState = state;

    if (currentState is SetFilter) {
      // If clicking the already selected category, deselect it
      if (currentState.subCategory == category) {
        emit(currentState.copyWith(subCategory: null));
      } else {
        // Select the new category (automatically deselects previous)
        emit(currentState.copyWith(subCategory: category));
      }
    } else {
      // If no filter state exists, create one with this category
      emit(SetFilter(subCategory: category));
    }
  }

  void setPriceFilter(double? price) {
    final currentState = state;

    if (currentState is SetFilter) {
      // Toggle logic: if same rating clicked, deselect it
      if (currentState.maxPrice == price) {
        emit(currentState.copyWith(maxPrice: null));
      } else {
        emit(currentState.copyWith(maxPrice: price));
      }
    } else {
      emit(SetFilter(maxPrice: price));
    }
  }

  void resetFilter() {
    emit(FilterInitial());
  }
}
