part of 'filter_cubit.dart';

sealed class FilterState extends Equatable {
  const FilterState();
  @override
  List<Object?> get props => [];
}

final class FilterInitial extends FilterState {}

final class SetCatagoryFilter extends FilterState {
  final FoodCategory? selectedCategory;
  const SetCatagoryFilter({this.selectedCategory});
  SetCatagoryFilter copyWith({FoodCategory? selectedCategory}) {
    return SetCatagoryFilter(selectedCategory: selectedCategory);
  }

  @override
  List<Object?> get props => [selectedCategory];
}

final class SetFilter extends FilterState {
  final FoodCategory? selectedCategory;
  final String? subCategory;
  final double? maxPrice;
  final int? minRating;

  const SetFilter({
    this.selectedCategory,
    this.maxPrice,
    this.minRating,
    this.subCategory,
  });
  //allows you to distinguish between: null (explicitly set to null) and _noValue (not provided, use current value)

  SetFilter copyWith({
    Object? selectedCategory = _noValue,
    Object? maxPrice = _noValue,
    Object? minRating = _noValue,
    Object? subCategory = _noValue,
  }) {
    return SetFilter(
      selectedCategory: selectedCategory == _noValue
          ? this.selectedCategory
          : selectedCategory as FoodCategory?,
      maxPrice: maxPrice == _noValue ? this.maxPrice : maxPrice as double?,
      minRating: minRating == _noValue ? this.minRating : minRating as int?,
      subCategory: subCategory == _noValue
          ? this.subCategory
          : subCategory as String?,
    );
  }

  static const _noValue = Object();
  void printFilterParams() {
    debugPrint('=== FILTER PARAMETERS ===');
    debugPrint('Selected Category: ${selectedCategory?.name ?? "None"}');
    debugPrint('Selected SubCategory: ${subCategory ?? "None"}');
    debugPrint('Max Price: ${maxPrice ?? "No limit"}');
    debugPrint('Min Rating: ${minRating ?? "No minimum"}');
    debugPrint('=========================');
  }

  @override
  List<Object?> get props => [
    selectedCategory,
    maxPrice,
    minRating,
    subCategory,
  ];
}

final class ApplyFilter extends FilterState {
  final FilterState? previousState;
  final FoodCategory? selectedCategory;
  final String? subCategory;
  final double? maxPrice;
  final int? minRating;
  const ApplyFilter({
    this.previousState,
    this.selectedCategory,
    this.maxPrice,
    this.minRating,
    this.subCategory,
  });
  @override
  List<Object?> get props => [
    selectedCategory,
    maxPrice,
    minRating,
    subCategory,
  ];
}
