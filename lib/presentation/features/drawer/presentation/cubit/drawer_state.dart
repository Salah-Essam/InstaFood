part of "drawer_cubit.dart";

sealed class DrawerState {}

final class DrawerInitial extends DrawerState {}

final class DrawerOpened extends DrawerState {
  DrawerOpened(this.type);
  final DrawerType type;
}
