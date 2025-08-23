import 'package:go_router/go_router.dart';
import 'package:insta_food/core/router/App_routes.dart';
import 'package:insta_food/presentation/features/home/presentation/home.dart';
import 'package:insta_food/presentation/features/search/presentation/search_screen.dart';
import 'package:insta_food/presentation/features/wrapper/wrapper.dart';

final GoRouter router = GoRouter(
  initialLocation: AppRoutes.wrapper,
  routes: [
    GoRoute(path: AppRoutes.home, builder: (context, state) => const Home()),
    GoRoute(
      path: AppRoutes.wrapper,
      builder: (context, state) => const Warpper(),
    ),
    // GoRoute(
    //   path: AppRoutes.productDetails,
    //   builder: (context, state) {
    //     final Products product = state.extra as Products;
    //     return ProductDetailScreen(
    //       products: product,
    //     );
    //   },
    // ),
    GoRoute(
      path: AppRoutes.search,
      builder: (context, state) => const SearchScreen(),
    ),
  ],
);
