import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:insta_food/core/di/register_items.dart';
import 'package:insta_food/core/network/APIs/api_service.dart';
import 'package:insta_food/core/network/Firebase/firebase_auth_service.dart';
import 'package:insta_food/core/network/network_info.dart';
import 'package:insta_food/core/storage/hive_service.dart';

final GetIt sl = GetIt.instance;

Future<void> setupLocator() async {
  await HiveService.init();
  await Firebase.initializeApp();
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
  //Features
  registerItems();
}
