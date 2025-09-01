import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;

import 'package:insta_food/core/di/di.dart';
import 'package:insta_food/core/routes/router_constants.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/core/utils/app_strings.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_state.dart';
import 'package:insta_food/presentation/features/cart/logic/cart_cubit.dart';
import 'package:insta_food/presentation/features/cart/logic/cart_state.dart';
import 'package:insta_food/presentation/features/order/firestore/order_firestore_services.dart';
import 'package:insta_food/presentation/widgets/shared_scaffold.dart';
import 'package:insta_food/presentation/features/order/presentation/widgets/order_confirmed/confirmed_icon.dart';
import 'package:insta_food/presentation/features/order/presentation/widgets/order_confirmed/track_order_button.dart';

class OrderConfirmedPage extends StatefulWidget {
  const OrderConfirmedPage({super.key});

  @override
  State<OrderConfirmedPage> createState() => _OrderConfirmedPageState();
}

class _OrderConfirmedPageState extends State<OrderConfirmedPage> {
  String? _orderId;
  String? _etaText;

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
    // Compute ETA text once
    _computeEtaIfNeeded();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.go(RouterConstants.bottomNavBar);
        return false;
      },
      child: SharedScaffold(
        appBarTitle: AppStrings.orderConfirmedTitle,
        fullYellow: true,
        pageDetails: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ConfirmedIcon(),
                const SizedBox(height: 24),
                Text(
                  AppStrings.orderConfirmedHeadline,
                  style: AppTextStyles.mediumText.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  AppStrings.orderPlacedSuccessfully,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 16),
                Text(
                  _etaText ?? 'Calculating delivery time…',
                  style: AppTextStyles.mediumText.copyWith(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 16),
                TrackOrderButton(
                  onTap: () async {
                    final allow = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text(AppStrings.enableLocationTitle),
                            content: const Text(AppStrings.enableLocationBody),
                            actions: [
                              TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text(AppStrings.notNow)),
                              TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text(AppStrings.allow)),
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
                ),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    AppStrings.supportReachOut,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w400),
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

  void _computeEtaIfNeeded() async {
    if (_etaText != null) return;
    DateTime baseTime = DateTime.now();
    // Try to use earliest addedAt from cart items
    final cartState = context.read<CartCubit>().state;
    if (cartState is CartLoaded && cartState.items.isNotEmpty) {
      final times = cartState.items
          .map((e) => e.addedAt ?? e.updatedAt)
          .whereType<DateTime>()
          .toList();
      if (times.isNotEmpty) {
        times.sort();
        baseTime = times.first;
      }
    }

    int etaMinutes = 20; // default fallback
    try {
      // Use location only if already permitted (avoid prompting here)
      final enabled = await Geolocator.isLocationServiceEnabled();
      final permission = await Geolocator.checkPermission();
      if (enabled && permission != LocationPermission.denied && permission != LocationPermission.deniedForever) {
        final pos = await Geolocator.getCurrentPosition();
        final user = LatLng(pos.latitude, pos.longitude);
        // Pseudo nearest restaurant: within ~2km
        final rand = math.Random();
        final offsetLat = (rand.nextDouble() - 0.5) * 0.02;
        final offsetLng = (rand.nextDouble() - 0.5) * 0.02;
        final rest = LatLng(user.latitude + offsetLat, user.longitude + offsetLng);
        final distKm = const Distance().as(LengthUnit.Kilometer, user, rest);
        final travelMinutes = (distKm / 0.5); // 0.5 km per minute ≈ 30km/h
        const prepMinutes = 10;
        etaMinutes = (prepMinutes + travelMinutes).clamp(5, 90).round();
      }
    } catch (_) {
      // keep fallback
    }

    final deliveryAt = baseTime.add(Duration(minutes: etaMinutes));
    final text = 'Delivery by ${_formatDeliveryDateTime(deliveryAt)}';
    if (!mounted) return;
    setState(() => _etaText = text);
  }

  String _formatDeliveryDateTime(DateTime dt) {
    final dow = DateFormat('EEE').format(dt); // Mon, Tue
    final day = dt.day;
    final suffix = _ordinalDaySuffix(day);
    final time = DateFormat('h:mm a').format(dt); // 4:00 PM
    return '$dow, $day$suffix, $time';
  }

  String _ordinalDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
