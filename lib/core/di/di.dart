import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:insta_food/core/network/Firebase/firebase_options.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:insta_food/core/di/register_items.dart';
import 'package:insta_food/core/network/APIs/api_service.dart';
import 'package:insta_food/core/network/Firebase/firebase_auth_service.dart';
import 'package:insta_food/core/network/network_info.dart';
import 'package:insta_food/core/storage/hive_service.dart';
import 'package:insta_food/presentation/features/drawer/presentation/cubit/drawer_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> setupLocator() async {
  await HiveService.init();
  // On web, Firebase.initializeApp must receive options; using generated options for all platforms
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //Register Firebase
  sl.registerLazySingleton<FirebaseAuthService>(() => FirebaseAuthService());
  //Register Connectivity
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  sl.registerLazySingleton<Dio>(() => Dio());

  sl.registerLazySingleton<ApiService>(() => ApiService());
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfo(connectivity: sl<Connectivity>()),
  );
  sl.registerLazySingleton<Box>(() => Hive.box(cacheItemsKey));
  sl.registerLazySingleton<DrawerCubit>(() => DrawerCubit());
  //Features
  registerItems();
}
