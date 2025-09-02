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
				await local.cacheMenus(items); // cache fresh data
				return Right(items);
			} catch (e) {
				// fallback to cache if available
				try {
					final cached = await local.getCachedMenus();
					if (cached.isNotEmpty) return Right(cached.where((i)=> i.restaurantID == restaurantId).toList());
				} catch (_) {}
				return Left(ServerFailure(e.toString()));
			}
		} else {
			try {
				final cached = await local.getCachedMenus();
				final filtered = cached.where((i) => i.restaurantID == restaurantId).toList();
				if (filtered.isEmpty) return Left(CacheFailure('No cached menu available'));
				return Right(filtered);
			} catch (e) {
				return Left(CacheFailure(e.toString()));
			}
		}
	}
}
