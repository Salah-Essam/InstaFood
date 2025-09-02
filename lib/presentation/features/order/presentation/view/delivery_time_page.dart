import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_food/core/routes/router_constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/presentation/widgets/shared_scaffold.dart';
import 'package:latlong2/latlong.dart';
import 'package:insta_food/core/utils/app_strings.dart';
import 'package:insta_food/presentation/features/order/presentation/widgets/delivery_time/address_pill_current.dart';
import 'package:insta_food/presentation/features/order/presentation/widgets/delivery_time/timeline_row.dart';

class DeliveryTimePage extends StatefulWidget {
  const DeliveryTimePage({super.key});

  @override
  State<DeliveryTimePage> createState() => _DeliveryTimePageState();
}

class _DeliveryTimePageState extends State<DeliveryTimePage> {
  LatLng? _user;
  LatLng? _restaurant;
  double? _etaMin;
  double? _distanceKm;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      await Geolocator.openLocationSettings();
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      return;
    }

    final pos = await Geolocator.getCurrentPosition();
    final user = LatLng(pos.latitude, pos.longitude);
    // For demo, pick a nearby restaurant ~1-3km away
    final rand = math.Random();
    final offsetLat = (rand.nextDouble() - 0.5) * 0.02; // ~2km
    final offsetLng = (rand.nextDouble() - 0.5) * 0.02;
    final rest = LatLng(user.latitude + offsetLat, user.longitude + offsetLng);

    final dist = const Distance().as(LengthUnit.Kilometer, user, rest);
    // Assume avg speed 30km/h -> 0.5km/min
    final eta = (dist / 0.5).clamp(5, 60); // between 5 and 60 mins

    if (mounted) {
      setState(() {
        _user = user;
        _restaurant = rest;
        _distanceKm = double.parse(dist.toStringAsFixed(2));
        _etaMin = double.parse((eta).toStringAsFixed(0));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      appBarTitle: AppStrings.deliveryTime,
      pageDetails: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.shippingAddress,
            style: AppTextStyles.greeting.copyWith(color: Colors.black),
          ),
          const SizedBox(height: 8),
          const AddressPillCurrent(),
          const SizedBox(height: 12),
          SizedBox(height: 180, child: _buildMap()),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                AppStrings.deliveryTime,
                style: AppTextStyles.mediumText.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                _etaMin != null ? '${_etaMin!.toStringAsFixed(0)} mins' : '—',
                style: AppTextStyles.mediumText.copyWith(
                  color: AppColors.primaryOrange,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (_distanceKm != null)
            Text(
              'Distance ~ ${_distanceKm!.toStringAsFixed(2)} km',
              style: AppTextStyles.mediumText.copyWith(
                color: Colors.black54,
                fontSize: 12,
              ),
            ),
          const SizedBox(height: 4),
          Text(
            AppStrings.estimatedDelivery,
            style: AppTextStyles.mediumText.copyWith(color: Colors.black54),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                TimelineRow(
                  title: 'Your order has been accepted',
                  time: '2 min',
                ),
                TimelineRow(
                  title: 'The restaurant is preparing your order',
                  time: '5 min',
                ),
                TimelineRow(
                  title: 'The delivery is on his way',
                  time: '10 min',
                ),
                TimelineRow(
                  title: 'Your order has been delivered',
                  time: '8 min',
                ),
                const SizedBox(height: 8),
                _ActionPills(
                  onReturnHome: () => context.go(RouterConstants.bottomNavBar),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    if (_user == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final markers = <Marker>[
      Marker(
        point: _user!,
        width: 40,
        height: 40,
        child: const Icon(
          Icons.person_pin_circle,
          color: AppColors.primaryOrange,
          size: 36,
        ),
      ),
      if (_restaurant != null)
        Marker(
          point: _restaurant!,
          width: 40,
          height: 40,
          child: const Icon(
            Icons.restaurant,
            color: Colors.redAccent,
            size: 28,
          ),
        ),
    ];

    final poly = _restaurant != null
        ? [
            Polyline(
              points: [_user!, _restaurant!],
              color: AppColors.primaryOrange,
              strokeWidth: 4,
            ),
          ]
        : <Polyline>[];

    return FlutterMap(
      options: MapOptions(initialCenter: _user!, initialZoom: 14),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c'],
        ),
        PolylineLayer(polylines: poly),
        MarkerLayer(markers: markers),
      ],
    );
  }

  // TimelineRow moved to widgets/delivery_time/timeline_row.dart
}

class _ActionPills extends StatelessWidget {
  const _ActionPills({required this.onReturnHome});
  final VoidCallback onReturnHome;

  @override
  Widget build(BuildContext context) {
    TextStyle style(Color c) => AppTextStyles.mediumText.copyWith(
      color: c,
      fontWeight: FontWeight.w600,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: onReturnHome,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.primaryOrange),
            ),
            child: Text(
              AppStrings.returnHome,
              style: style(AppColors.primaryOrange),
            ),
          ),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.orange2,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              AppStrings.trackOrder,
              style: style(AppColors.primaryOrange),
            ),
          ),
        ),
      ],
    );
  }
}
