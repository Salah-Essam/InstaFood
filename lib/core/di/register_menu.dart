import 'package:hive/hive.dart';
import 'package:insta_food/core/di/di.dart';
import 'package:insta_food/core/network/APIs/api_service.dart';
import 'package:insta_food/core/network/network_info.dart';
import 'package:insta_food/core/storage/hive_service.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';
import 'package:insta_food/presentation/features/menu/data/data_source/menu_local_source.dart';
import 'package:insta_food/presentation/features/menu/data/data_source/menu_remote_source.dart';
import 'package:insta_food/presentation/features/menu/data/Repository/menu_repository.dart';
import 'package:insta_food/presentation/features/menu/presentation/cubit/menu_cubit.dart';

void registerMenu() {
  // Reuse existing items box for menu caching OR create a dedicated box. Here we reuse items cache.
  sl.registerLazySingleton<MenuLocalSource>(
    () => MenuLocalDataSourceImpl(box: sl<Box<ItemModel>>(instanceName: cacheItemsKey)),
  );
  sl.registerLazySingleton<MenuRemoteSource>(
    () => MenuRemoteSourceImpl(apiService: sl<ApiService>()),
  );
  sl.registerLazySingleton<MenuRepository>(
    () => MenuRepositoryImpl(remote: sl<MenuRemoteSource>(), local: sl<MenuLocalSource>(), networkInfo: sl<NetworkInfo>()),
  );
  sl.registerFactory<MenuCubit>(
    () => MenuCubit(repository: sl<MenuRepository>()),
  );
}