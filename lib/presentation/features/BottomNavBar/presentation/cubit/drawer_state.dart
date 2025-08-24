part of "drawer_cubit.dart";

sealed class DrawerState {}

final class DrawerInitial extends DrawerState {}

final class ShowProfileDrawer extends DrawerState {
  ShowProfileDrawer({required this.profileDrawer});
  final Widget profileDrawer;
}

final class ShowCartDrawer extends DrawerState {
  ShowCartDrawer({required this.cartDrawer});
  final Widget cartDrawer;
}

final class ShowNotificationsDrawer extends DrawerState {
  ShowNotificationsDrawer({required this.notificationsDrawer});
  final Widget notificationsDrawer;
}
