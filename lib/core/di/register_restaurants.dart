import 'package:hive/hive.dart';
import 'package:insta_food/core/di/di.dart';
import 'package:insta_food/core/network/APIs/api_service.dart';
import 'package:insta_food/core/network/network_info.dart';
import 'package:insta_food/presentation/features/Restaurants/data/data_source/local_data.dart';
import 'package:insta_food/presentation/features/Restaurants/data/data_source/remote_data.dart';
import 'package:insta_food/presentation/features/Restaurants/data/repository/restaurants_repository.dart';
import 'package:insta_food/presentation/features/Restaurants/presentation/cubit/restaurants_cubit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:insta_food/core/storage/hive_service.dart';
import 'package:insta_food/presentation/features/Restaurants/data/model/restaurant_model.dart';

void registerRestaurants() {
  sl.registerLazySingleton<RestaurantsLocalDataSource>(
    () => RestaurantsLocalDataSourceImpl(box: sl<Box<Restaurant>>(instanceName: cacheRestaurantsKey)),
  );
  sl.registerLazySingleton<RestaurantsRemoteDataSource>(
    () => RestaurantsRemoteDataSourceImpl(apiService: sl<ApiService>()),
  );
  sl.registerLazySingleton<RestaurantsRepository>(
    () => RestaurantsRepository(
      local: sl<RestaurantsLocalDataSource>(),
      remote: sl<RestaurantsRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );
  sl.registerFactory<RestaurantsCubit>(
    () => RestaurantsCubit(
      repository: sl<RestaurantsRepository>(),
      connectivity: sl<Connectivity>(),
    )..initialize(),
  );
}