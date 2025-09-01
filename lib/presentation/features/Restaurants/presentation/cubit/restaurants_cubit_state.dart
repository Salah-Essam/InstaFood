
import 'package:insta_food/presentation/features/Restaurants/data/model/restaurant_model.dart';

class RestaurantsState {}

class RestaurantsInitial extends RestaurantsState {}

class RestaurantsLoading extends RestaurantsState {}

class RestaurantsLoaded extends RestaurantsState {
  final List<Restaurant> restaurants;

  RestaurantsLoaded({required this.restaurants});
}

class RestaurantsError extends RestaurantsState {
  final String message;

  RestaurantsError({required this.message});
}

class RestaurantsToast extends RestaurantsState {
  final String message;
  final RestaurantsState previous;
  RestaurantsToast({required this.message, required this.previous});
}