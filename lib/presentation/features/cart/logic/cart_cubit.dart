import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_food/core/session/session_manager.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_state.dart';
import 'package:insta_food/presentation/features/cart/data/models/cart_item_model.dart';
import 'package:insta_food/presentation/features/cart/data/repositories/cart_repository.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
	final CartRepository repo;
	final AuthCubit authCubit;
	final SessionManager session;
	StreamSubscription? _sub;

	CartCubit({required this.repo, required this.authCubit, required this.session})
			: super(CartInitial()) {
		_bindAuth();
			// Start watching immediately if already authenticated
			final s = authCubit.state;
			if (s is Authenticated && (s.user.id ?? '').isNotEmpty) {
				watch(s.user.id!);
			}
	}

	void _bindAuth() {
		authCubit.stream.listen((state) {
			if (state is Authenticated) {
				watch(state.user.id ?? session.getUser()?.id ?? '');
			} else {
				_sub?.cancel();
				emit(CartLoaded(items: const [], tax: 1.0, delivery: 2.0));
			}
		});
	}

	String? _currentUid() {
		final s = authCubit.state;
		if (s is Authenticated) return s.user.id;
		return session.getUser()?.id;
	}

	void watch(String uid) {
		_sub?.cancel();
		emit(CartLoading());
		_sub = repo.watchCart(uid).listen(
			(items) => emit(CartLoaded(items: items, tax: 1.0, delivery: 2.0)),
			onError: (e) => emit(CartError(e.toString())),
		);
	}

	Future<void> addOrUpdate(CartItemModel item) async {
		final uid = _currentUid();
		if (uid == null || uid.isEmpty) {
			emit(CartActionBlocked('login_required'));
			return;
		}
		await repo.addOrUpdate(item, uid);
	}

	Future<void> remove(String cartItemId) async {
		final uid = _currentUid();
		if (uid == null || uid.isEmpty) {
			emit(CartActionBlocked('login_required'));
			return;
		}
		await repo.remove(cartItemId, uid);
	}

	Future<void> clear() async {
		final uid = _currentUid();
		if (uid == null || uid.isEmpty) {
			emit(CartActionBlocked('login_required'));
			return;
		}
		await repo.clear(uid);
	}

	@override
	Future<void> close() {
		_sub?.cancel();
		return super.close();
	}
}

