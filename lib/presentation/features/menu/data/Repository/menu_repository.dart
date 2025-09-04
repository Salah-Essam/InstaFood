import 'package:dartz/dartz.dart';
import 'package:insta_food/core/errors/failures.dart';
import 'package:insta_food/core/network/network_info.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';
import 'package:insta_food/presentation/features/menu/data/data_source/menu_local_source.dart';
import 'package:insta_food/presentation/features/menu/data/data_source/menu_remote_source.dart';

abstract class MenuRepository {
	Future<Either<Failure, List<ItemModel>>> getMenu(int restaurantId, {String? sortByPrice});
}

class MenuRepositoryImpl implements MenuRepository {
	final MenuRemoteSource remote;
	final MenuLocalSource local;
	final NetworkInfo networkInfo;
	MenuRepositoryImpl({required this.remote, required this.local, required this.networkInfo});

	@override
	Future<Either<Failure, List<ItemModel>>> getMenu(int restaurantId, {String? sortByPrice}) async {
		final online = await networkInfo.isConnected;
		if (online) {
			try {
				final items = await remote.fetchMenu(restaurantId, sortByPrice: sortByPrice);
				// Only cache the canonical (unsorted) list to avoid polluting cache with sorted variants.
				if (sortByPrice == null) {
					await local.cacheMenusForRestaurant(restaurantId, items);
				}
				return Right(items);
			} catch (e) {
				// fallback to cache if available for this restaurant
				try {
					final cached = await local.getCachedMenuForRestaurant(restaurantId);
					if (cached.isNotEmpty) return Right(_maybeSort(cached, sortByPrice));
				} catch (_) {}
				return Left(ServerFailure(e.toString()));
			}
		} else {
			try {
				final cached = await local.getCachedMenuForRestaurant(restaurantId);
				if (cached.isEmpty) return Left(CacheFailure('No cached menu available'));
				return Right(_maybeSort(cached, sortByPrice));
			} catch (e) {
				return Left(CacheFailure(e.toString()));
			}
		}
	}

	List<ItemModel> _maybeSort(List<ItemModel> items, String? sortByPrice) {
		if (sortByPrice == null) return items;
		final sorted = List<ItemModel>.from(items);
			if (sortByPrice == 'asc') {
				sorted.sort((a,b)=> (a.itemPrice).compareTo(b.itemPrice));
			} else if (sortByPrice == 'desc') {
				sorted.sort((a,b)=> (b.itemPrice).compareTo(a.itemPrice));
		}
		return sorted;
	}
}
