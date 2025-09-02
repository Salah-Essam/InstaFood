import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_food/core/routes/router_constants.dart';
import 'package:insta_food/core/theme/app_colors.dart';

class PlaceOrderButton extends StatelessWidget {
  const PlaceOrderButton({super.key, required this.disabled});

  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightOrange,
          foregroundColor: AppColors.primaryOrange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: disabled
            ? null
            : () {
                context.push(RouterConstants.payment);
              },
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: Text('Place Order'),
        ),
      ),
    );
  }
}
