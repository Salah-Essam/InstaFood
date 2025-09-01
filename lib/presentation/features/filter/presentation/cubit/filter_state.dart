part of 'filter_cubit.dart';

sealed class FilterState extends Equatable {
  const FilterState();
  @override
  List<Object?> get props => [];
}

final class FilterInitial extends FilterState {}

final class SetFilter extends FilterState {
  final FoodCategory? selectedCategory;
  final double? maxPrice;
  final int? minRating;

  const SetFilter({this.selectedCategory, this.maxPrice, this.minRating});

  SetFilter copyWith({
    Object? selectedCategory = _noValue,
    Object? maxPrice = _noValue,
    Object? minRating = _noValue,
  }) {
    return SetFilter(
      selectedCategory: selectedCategory == _noValue
          ? this.selectedCategory
          : selectedCategory as FoodCategory?,
      maxPrice: maxPrice == _noValue ? this.maxPrice : maxPrice as double?,
      minRating: minRating == _noValue ? this.minRating : minRating as int?,
    );
  }

  static const _noValue = Object();
  void printFilterParams() {
    print('=== FILTER PARAMETERS ===');
    print('Selected Category: ${selectedCategory?.name ?? "None"}');
    print('Max Price: ${maxPrice ?? "No limit"}');
    print('Min Rating: ${minRating ?? "No minimum"}');
    print('=========================');
  }

  @override
  List<Object?> get props => [selectedCategory, maxPrice, minRating];
}

final class ApplyFilter extends FilterState {}
