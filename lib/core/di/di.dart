import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:insta_food/core/network/Firebase/firebase_options.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:insta_food/core/di/register_items.dart';
import 'package:insta_food/core/network/APIs/api_service.dart';
import 'package:insta_food/core/network/network_info.dart';
import 'package:insta_food/core/storage/hive_service.dart';
import 'package:insta_food/presentation/features/auth/data/repository/auth_repository.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:insta_food/presentation/features/drawer/presentation/cubit/drawer_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final GetIt sl = GetIt.instance;

Future<void> setupLocator() async {
  // Initialize Hive
  await HiveService.init();

  // Open user box
  final userBox = await Hive.openBox('userBox');

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Register Firebase services
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  // Register repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepository(sl(), sl(), userBox),
  );

  // Register cubits
  sl.registerFactory(() => AuthCubit(sl()));
  sl.registerLazySingleton<DrawerCubit>(() => DrawerCubit());

  // Register network services
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<ApiService>(() => ApiService());
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfo(connectivity: sl<Connectivity>()),
  );

  // Register cache box
  sl.registerLazySingleton<Box>(() => Hive.box(cacheItemsKey));

  registerItems();
}
