import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_food/features/BottomNavBar/presentation/bloc/drawer_cubit.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/home';

  const HomePage({super.key, this.scaffoldKey, this.openDrawerCallback});

  final GlobalKey<ScaffoldState>? scaffoldKey;
  final Function(DrawerCubit, String)? openDrawerCallback;

  @override
  Widget build(BuildContext context) {
    final drawerCubit = context.read<DrawerCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('InstaFood')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                openDrawerCallback!(drawerCubit, "profile");
                scaffoldKey?.currentState?.openEndDrawer();
              },
              child: const Text('profile Drawer'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                openDrawerCallback!(drawerCubit, "cart");
                scaffoldKey?.currentState?.openEndDrawer();
              },
              child: const Text('cart Drawer'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                openDrawerCallback!(drawerCubit, "notifications");
                scaffoldKey?.currentState?.openEndDrawer();
              },
              child: const Text('notifications Drawer'),
            ),
          ],
        ),
      ),
    );
  }
}
