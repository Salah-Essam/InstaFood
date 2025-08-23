import 'package:flutter/material.dart';
import 'package:insta_food/core/app_router.dart';

void main() {
  runApp(const InstaFood());
}

class InstaFood extends StatelessWidget {
  const InstaFood({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'InstaFood',
      initialRoute: AppRoutes.bottomNavBar,
      routes: AppRouter().getRoutes(context),
    );
  }
}
