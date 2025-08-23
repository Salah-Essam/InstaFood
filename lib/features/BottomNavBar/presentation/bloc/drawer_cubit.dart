import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_food/features/BottomNavBar/presentation/widgets/cart_drawer.dart';
import 'package:insta_food/features/BottomNavBar/presentation/widgets/notifications_drawer.dart';
import 'package:insta_food/features/BottomNavBar/presentation/widgets/profile_drawer.dart';

class DrawerCubit extends Cubit<Widget> {
  DrawerCubit() : super(ProfileDrawer());

  void showProfileDrawer() => emit(ProfileDrawer());
  void showCartDrawer() => emit(CartDrawer());
  void showNotificationsDrawer() => emit(NotificationsDrawer());
}
