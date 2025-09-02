import 'package:flutter/material.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_food/presentation/features/favorites/domain/favorites_repository.dart';
import 'package:insta_food/presentation/features/items/data/model/item_model.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit({required this.repo}) : super(FavoritesState(items: const []));

  final FavoritesRepository repo;

  void init([List<ItemModel>? initial]) {
    if (initial != null && initial.isNotEmpty) {
      for (final it in initial) {
        repo.add(it);
      }
    }
    emit(FavoritesState(items: repo.favorites));
  }

  void toggle(ItemModel item) {
    repo.toggle(item);
    emit(FavoritesState(items: repo.favorites));
  }

  bool isFavorite(int itemId) => repo.isFavorite(itemId);

  void clear() {
    repo.clear();
    emit(FavoritesState(items: const []));
  }
}
