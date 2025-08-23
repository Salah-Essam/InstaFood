import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_food/features/BottomNavBar/presentation/cubit/drawer_cubit.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/home';

  const HomePage({super.key, this.scaffoldKey, this.openDrawerCallback});

  final GlobalKey<ScaffoldState>? scaffoldKey;
  final Function(DrawerCubit, DrawerType)? openDrawerCallback;

  @override
  Widget build(BuildContext context) {
    final drawerCubit = BlocProvider.of<DrawerCubit>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('InstaFood')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                openDrawerCallback!(drawerCubit, DrawerType.profile);
                scaffoldKey?.currentState?.openEndDrawer();
              },
              child: const Text('profile Drawer'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                openDrawerCallback!(drawerCubit, DrawerType.cart);
                scaffoldKey?.currentState?.openEndDrawer();
              },
              child: const Text('cart Drawer'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                openDrawerCallback!(drawerCubit, DrawerType.notifications);
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
