import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_food/presentation/features/cart/logic/cart_cubit.dart';
import 'package:insta_food/presentation/features/cart/logic/cart_state.dart';
import 'package:insta_food/presentation/features/order/firestore/order_firestore_constants.dart';
import 'package:insta_food/presentation/features/order/firestore/order_firestore_services.dart';
import 'package:insta_food/presentation/features/order/logic/order_state.dart';
import 'package:insta_food/presentation/features/cart/data/models/cart_item_model.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_state.dart';

class OrderCubit extends Cubit<OrderState> {
	final OrderFirestoreService service;
	final CartCubit cartCubit;
	final AuthCubit authCubit;
	OrderCubit({required this.service, required this.cartCubit, required this.authCubit})
			: super(OrderInitial());

	Future<void> placeOrder({required String shippingAddress}) async {
		final auth = authCubit.state;
		if (auth is! Authenticated || (auth.user.id ?? '').isEmpty) {
			emit(OrderError('login_required'));
			return;
		}

		final uid = auth.user.id!;
		final cartState = cartCubit.state;
		if (cartState is! CartLoaded || cartState.items.isEmpty) {
			emit(OrderError('cart_empty'));
			return;
		}

		emit(OrderPlacing());
		try {
			final payload = _buildOrderPayload(cartState, shippingAddress);
			final orderId = await service.createActiveOrder(uid: uid, order: payload);
			// NOTE: Do not clear cart here per current flow (will be done later after payment).
			emit(OrderPlaced(orderId));
		} catch (e) {
			emit(OrderError(e.toString()));
		}
	}

	Future<void> completeAndClear({required String orderId, String? transactionId}) async {
		final auth = authCubit.state;
		if (auth is! Authenticated || (auth.user.id ?? '').isEmpty) {
			emit(OrderError('login_required'));
			return;
		}
		final uid = auth.user.id!;
		try {
			await service.markOrderCompleted(uid: uid, orderId: orderId, transactionId: transactionId);
			await cartCubit.clear();
			emit(OrderPlaced(orderId));
		} catch (e) {
			emit(OrderError(e.toString()));
		}
	}

	Map<String, dynamic> _buildOrderPayload(CartLoaded cart, String shippingAddress) {
		return {
			OrderFs.fItems: cart.items.map(_cartItemToMap).toList(),
			OrderFs.fSubtotal: cart.subtotal,
			OrderFs.fTax: cart.tax,
			OrderFs.fDeliveryFee: cart.delivery,
			OrderFs.fTotal: cart.total,
			OrderFs.fShippingAddress: shippingAddress,
			OrderFs.fPayment: {
				'method': 'cod',
				'status': 'pending',
			},
		};
	}

	Map<String, dynamic> _cartItemToMap(CartItemModel it) => {
				'cartItemId': it.cartItemId,
				'itemId': it.itemId,
				'itemName': it.itemName,
				'imageUrl': it.imageUrl,
				'restaurantId': it.restaurantId,
				'restaurantName': it.restaurantName,
				'unitPrice': it.unitPrice,
				'quantity': it.quantity,
				'options': it.options,
			};
}

