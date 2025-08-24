import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_food/presentation/features/BottomNavBar/presentation/widgets/cart_drawer.dart';
import 'package:insta_food/presentation/features/BottomNavBar/presentation/widgets/notifications_drawer.dart';
import 'package:insta_food/presentation/features/BottomNavBar/presentation/widgets/profile_drawer.dart';

part 'drawer_state.dart';

class DrawerCubit extends Cubit<DrawerState> {
  DrawerCubit() : super(DrawerInitial());

  void getDrawerData(DrawerType type) {
    switch (type) {
      case DrawerType.profile:
        emit(ShowProfileDrawer(profileDrawer: ProfileDrawer()));
        break;
      case DrawerType.cart:
        emit(ShowCartDrawer(cartDrawer: CartDrawer()));
        break;
      case DrawerType.notifications:
        emit(
          ShowNotificationsDrawer(notificationsDrawer: NotificationsDrawer()),
        );
    }
  }
}

enum DrawerType {
  profile('profile'),
  cart('cart'),
  notifications('notifications');

  const DrawerType(this.value);
  final String value;
}
