import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:insta_food/core/connection/networkInfo.dart';
import 'package:insta_food/core/di/register_items.dart';
import 'package:insta_food/core/firebase/auth_services.dart';
import 'package:insta_food/core/hive/hive_setup.dart';
import 'package:insta_food/core/remote/api_service.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';

final GetIt sl = GetIt.instance;

Future<void> setupLocator() async {
  await HiveSetup.init();
  await Firebase.initializeApp();
  //Register Firebase
  sl.registerLazySingleton<AuthService>(() => AuthService());
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
