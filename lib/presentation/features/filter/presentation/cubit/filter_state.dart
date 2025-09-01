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
    FoodCategory? selectedCategory,
    double? maxPrice,
    int? minRating,
  }) {
    return SetFilter(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating,
    );
  }

  @override
  List<Object?> get props => [selectedCategory, maxPrice, minRating];
}

final class ApplyFilter extends FilterState {}
