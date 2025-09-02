import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:insta_food/core/di/register_restaurants.dart';
import 'package:insta_food/core/network/Firebase/firebase_auth_service.dart';
import 'package:insta_food/core/network/Firebase/firebase_options.dart';
import 'package:get_it/get_it.dart';
import 'package:insta_food/core/di/register_items.dart';
import 'package:insta_food/core/network/APIs/api_service.dart';
import 'package:insta_food/core/network/network_info.dart';
import 'package:insta_food/core/storage/hive_service.dart';
import 'package:insta_food/presentation/features/Restaurants/data/model/restaurant_model.dart';
import 'package:insta_food/presentation/features/auth/data/repository/auth_repository.dart';
import 'package:insta_food/core/network/Firebase/firebase_firestore_service.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';
import 'package:insta_food/presentation/features/filter/presentation/cubit/filter_cubit.dart';
import 'package:insta_food/presentation/features/order/logic/order_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:insta_food/core/session/session_manager.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:insta_food/presentation/features/drawer/presentation/cubit/drawer_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_food/presentation/features/cart/firestore/cart_firestore_services.dart';
import 'package:insta_food/presentation/features/order/firestore/order_firestore_services.dart';
import 'package:insta_food/presentation/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:insta_food/presentation/features/cart/data/repos/cart_repository_impl.dart';
import 'package:insta_food/presentation/features/cart/data/repositories/cart_repository.dart';
import 'package:insta_food/presentation/features/cart/logic/cart_cubit.dart';
import 'package:insta_food/presentation/features/order/data/repos/orders_repository.dart';
import 'package:insta_food/presentation/features/order/logic/orders_cubit.dart';


final GetIt sl = GetIt.instance;

Future<void> setupLocator() async {
  // Initialize Hive
  await HiveService.init();


  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Register Firebase raw instances
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  // Core Firestore wrapper service (needed by AuthRepository)
  sl.registerLazySingleton<FirebaseFirestoreService>(
    () => FirebaseFirestoreService(firestore: sl<FirebaseFirestore>()),
  );

  // Higher level Firebase services (auth service kept if other layers still use it)
  sl.registerLazySingleton<FirebaseAuthService>(
    () => FirebaseAuthService(firebaseAuth: sl()),
  );
  
  // Feature Firestore services
  sl.registerLazySingleton<CartFirestoreService>(
    () => CartFirestoreService(firestore: sl()),
  );
  sl.registerLazySingleton<OrderFirestoreService>(
    () => OrderFirestoreService(firestore: sl()),
  );

  // Session manager (SharedPreferences)
  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SessionManager>(
    () => SessionManager(prefs: sharedPrefs),
  );


  // Auth repository 
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository(
        sl<FirebaseAuth>(),
        sl<FirebaseFirestoreService>(),
      ));

  // Register cubits
  sl.registerFactory(() => AuthCubit(sl()));
  sl.registerLazySingleton<DrawerCubit>(() => DrawerCubit());

  sl.registerLazySingleton<FilterCubit>(() => FilterCubit());

  // Cart feature
  sl.registerLazySingleton<CartRemoteDataSource>(
      () => CartRemoteDataSourceImpl(service: sl<CartFirestoreService>()));

  sl.registerLazySingleton<CartRepository>(
      () => CartRepositoryImpl(remote: sl<CartRemoteDataSource>()));

  sl.registerFactory<CartCubit>(() => CartCubit(
        repo: sl<CartRepository>(),
        authCubit: sl<AuthCubit>(),
        session: sl<SessionManager>(),
      ));

  // Order cubit factory
  sl.registerFactory<OrderCubit>(() => OrderCubit(
        service: sl<OrderFirestoreService>(),
        cartCubit: sl<CartCubit>(),
        authCubit: sl<AuthCubit>(),
      ));

  // Orders (My Orders) repository and cubit
  sl.registerLazySingleton<OrdersRepository>(() => OrdersRepositoryFs(sl<FirebaseFirestore>()));
  sl.registerFactory<OrdersCubit>(() => OrdersCubit(repo: sl<OrdersRepository>(), auth: sl<AuthCubit>()));


  // Register network services
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<ApiService>(() => ApiService());
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfo(connectivity: sl<Connectivity>()),
  );

 
sl.registerLazySingleton<Box<ItemModel>>(
  () => Hive.box<ItemModel>(cacheItemsKey),
  instanceName: cacheItemsKey,
);

sl.registerLazySingleton<Box<Restaurant>>(
  () => Hive.box<Restaurant>(cacheRestaurantsKey),
  instanceName: cacheRestaurantsKey,
);

  registerRestaurants();
  registerItems();
}
  