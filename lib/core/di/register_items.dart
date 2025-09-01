import 'package:hive/hive.dart';
import 'package:insta_food/core/di/di.dart';
import 'package:insta_food/core/network/APIs/api_service.dart';
import 'package:insta_food/core/network/network_info.dart';
import 'package:insta_food/presentation/features/filter/presentation/cubit/filter_cubit.dart';
import 'package:insta_food/presentation/features/items/data/data%20sources/local_data_source.dart';
import 'package:insta_food/presentation/features/items/data/data%20sources/remote_data_source.dart';
import 'package:insta_food/presentation/features/items/data/repositories/item_repository.impl.dart';
import 'package:insta_food/presentation/features/items/data/repositories/item_repository.dart';
import 'package:insta_food/presentation/features/items/presentation/cubit/item_cubit.dart';

void registerItems() {
  sl.registerLazySingleton<ItemsLocalDataSource>(
    () => ProductLocalDataSourceImpl(box: sl<Box>()),
  );
  sl.registerLazySingleton<ItemsRemoteDataSource>(
    () => ItemsRemoteDataSourceImpl(apiService: sl<ApiService>()),
  );

  sl.registerLazySingleton<ItemRepository>(
    () => ItemRepoImpl(
      localDataSource: sl<ItemsLocalDataSource>(),
      remoteDataSource: sl<ItemsRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );
  sl.registerFactory<ItemCubit>(
    () => ItemCubit(
      itemRepository: sl<ItemRepository>(),
      filterCubit: sl<FilterCubit>(),
    ),
  );
}
