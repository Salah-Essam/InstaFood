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
    if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) return;

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
      appBarTitle: 'Delivery time',
      pageDetails: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Shipping Address', style: AppTextStyles.greeting.copyWith(color: Colors.black)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF3E9B5),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on_outlined, color: Colors.black87, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Your current location',
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.mediumText.copyWith(color: Colors.black)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: _buildMap(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text('Delivery Time', style: AppTextStyles.mediumText.copyWith(color: Colors.black, fontWeight: FontWeight.w600)),
              const Spacer(),
              Text(_etaMin != null ? '${_etaMin!.toStringAsFixed(0)} mins' : '—',
                  style: AppTextStyles.mediumText.copyWith(color: AppColors.primaryOrange, fontWeight: FontWeight.w700)),
            ],
          ),
          if (_distanceKm != null)
            Text('Distance ~ ${_distanceKm!.toStringAsFixed(2)} km',
                style: AppTextStyles.mediumText.copyWith(color: Colors.black54, fontSize: 12)),
          const SizedBox(height: 4),
          Text('Estimated Delivery', style: AppTextStyles.mediumText.copyWith(color: Colors.black54)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2)),
              ],
            ),
            child: Column(
              children: [
                _timelineRow('Your order has been accepted', '2 min'),
                _timelineRow("The restaurant is preparing your order", '5 min'),
                _timelineRow('The delivery is on his way', '10 min'),
                _timelineRow('Your order has been delivered', '8 min'),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _pill('Return Home', Colors.white, AppColors.primaryOrange, border: true, onTap: () {
                      context.go(RouterConstants.bottomNavBar);
                    }),
                    _pill('Track Order', AppColors.orange2, AppColors.primaryOrange),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pill(String text, Color bg, Color fg, {bool border = false, VoidCallback? onTap}) {
    final child = Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(24),
        border: border ? Border.all(color: AppColors.primaryOrange) : null,
      ),
      child: Text(text, style: AppTextStyles.mediumText.copyWith(color: fg, fontWeight: FontWeight.w600)),
    );
    return onTap == null ? child : InkWell(onTap: onTap, borderRadius: BorderRadius.circular(24), child: child);
  }

  Widget _timelineRow(String title, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primaryOrange, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Expanded(child: Text(title, style: AppTextStyles.mediumText.copyWith(color: Colors.black)) ),
          Text(time, style: AppTextStyles.mediumText.copyWith(color: Colors.black54)),
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
        child: const Icon(Icons.person_pin_circle, color: AppColors.primaryOrange, size: 36),
      ),
      if (_restaurant != null)
        Marker(
          point: _restaurant!,
          width: 40,
          height: 40,
          child: const Icon(Icons.restaurant, color: Colors.redAccent, size: 28),
        ),
    ];

    final poly = _restaurant != null
        ? [
            Polyline(points: [_user!, _restaurant!], color: AppColors.primaryOrange, strokeWidth: 4),
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
}
