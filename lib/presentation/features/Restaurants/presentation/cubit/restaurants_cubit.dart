import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_food/presentation/features/Restaurants/data/model/restaurant_model.dart';
import 'package:insta_food/presentation/features/Restaurants/data/repository/restaurants_repository.dart';
import 'package:insta_food/presentation/features/Restaurants/presentation/cubit/restaurants_cubit_state.dart';
import 'package:insta_food/presentation/features/Restaurants/presentation/widgets/restaurant_filters.dart';

class RestaurantsCubit extends Cubit<RestaurantsState> {
  final RestaurantsRepository repository;
  final Connectivity connectivity;

  List<Restaurant> _full = [];
  List<Restaurant> _current = [];
  StreamSubscription<List<ConnectivityResult>>? _connSub;
  bool _wasOffline = false;

  RestaurantsCubit({required this.repository, required this.connectivity}) : super(RestaurantsInitial());

  void initialize() {
    _monitorConnectivity();
    fetchAll(initial: true);
  }

  void _monitorConnectivity() {
    _connSub = connectivity.onConnectivityChanged.listen((results) async {
      final online = results.any((r) => r != ConnectivityResult.none);
      if (!online) {
        _wasOffline = true;
        emit(RestaurantsToast(message: 'Internet disconnected', previous: state));
      } else {
        if (_wasOffline) {
          _wasOffline = false;
          emit(RestaurantsToast(message: 'Internet is back', previous: state));
          await fetchAll(refresh: true);
        }
      }
    });
  }

  Future<void> fetchAll({bool initial = false, bool refresh = false}) async {
    if (initial) emit(RestaurantsLoading());
    try {
  final list = await repository.fetchAll();
  _full = list;
  _current = list;
  emit(RestaurantsLoaded(restaurants: _current));
    } catch (_) {
      // fallback to cache already attempted in repository
      if (state is! RestaurantsLoaded) {
        emit(RestaurantsError(message: 'Failed to load restaurants'));
      }
    }
  }

  Future<void> applyFilter({required RestaurantFilterType filterType, String? query}) async {
    if (filterType == RestaurantFilterType.all || (query == null || query.isEmpty)) {
      _current = List.unmodifiable(_full);
      emit(RestaurantsLoaded(restaurants: _current));
      return;
    }
    final q = query.trim();
    List<Restaurant> list;
    switch (filterType) {
      case RestaurantFilterType.name:
        list = await repository.filterByName(q);
        break;
      case RestaurantFilterType.address:
        list = await repository.filterByAddress(q);
        break;
      case RestaurantFilterType.cuisine:
        list = await repository.filterByCuisine(q);
        break;
      case RestaurantFilterType.all:
        list = _full;
        break;
    }

    _current = list;
    emit(RestaurantsLoaded(restaurants: _current));
  }

  @override
  Future<void> close() {
    _connSub?.cancel();
    return super.close();
  }
}