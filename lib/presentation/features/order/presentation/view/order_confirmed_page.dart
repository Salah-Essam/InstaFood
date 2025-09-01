import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_food/core/routes/router_constants.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/presentation/widgets/shared_scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_state.dart';
import 'package:insta_food/presentation/features/cart/logic/cart_cubit.dart';
import 'package:insta_food/presentation/features/order/firestore/order_firestore_services.dart';
import 'package:insta_food/core/di/di.dart';
import 'package:geolocator/geolocator.dart';

class OrderConfirmedPage extends StatefulWidget {
  const OrderConfirmedPage({super.key});

  @override
  State<OrderConfirmedPage> createState() => _OrderConfirmedPageState();
}

class _OrderConfirmedPageState extends State<OrderConfirmedPage> {
  String? _orderId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Receive orderId via GoRouter.extra
    _orderId ??= GoRouterState.of(context).extra as String?;
    if (_orderId != null) {
      // Mark as completed and clear cart once (side-effect) without requiring OrderCubit
      final auth = context.read<AuthCubit>().state;
      final cart = context.read<CartCubit>();
      if (auth is Authenticated && (auth.user.id ?? '').isNotEmpty) {
        final uid = auth.user.id!;
        // Fire-and-forget
        sl<OrderFirestoreService>()
            .markOrderCompleted(uid: uid, orderId: _orderId!)
            .then((_) => cart.clear())
            .catchError((_) {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.go(RouterConstants.bottomNavBar);
        return false;
      },
      child: SharedScaffold(
      appBarTitle: 'Order Confirmed',
      pageDetails: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Big circular icon placeholder similar to screenshot
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: AppColors.orange2.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryOrange, width: 6),
                ),
                child: Center(
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('¡Order Confirmed!',
                  style: AppTextStyles.mediumText.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                  )),
              const SizedBox(height: 8),
              Text('Your order has been placed\nsuccessfully',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.mediumText.copyWith(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  )),
              const SizedBox(height: 16),
              Text('Delivery by Thu, 29th, 4:00 PM',
                  style: AppTextStyles.mediumText.copyWith(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  )),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final allow = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Enable location?'),
                          content: const Text('We need your GPS to track your order in real time.'),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Not now')),
                            TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Allow')),
                          ],
                        ),
                      ) ??
                      false;
                  if (!allow) return;
                  // Ask for GPS permission first
                  LocationPermission permission = await Geolocator.checkPermission();
                  if (permission == LocationPermission.denied) {
                    permission = await Geolocator.requestPermission();
                  }
                  if (!mounted) return;
                  context.push(RouterConstants.deliveryTime);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10),
                  child: Text('Track my order',
                      style: AppTextStyles.mediumText.copyWith(
                        color: AppColors.primaryOrange,
                        fontWeight: FontWeight.w600,
                      )),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'If you have any questions, please reach out directly to our customer support',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.mediumText.copyWith(
                    color: Colors.black87,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
