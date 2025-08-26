import 'package:flutter_bloc/flutter_bloc.dart';

part 'drawer_state.dart';

class DrawerCubit extends Cubit<DrawerState> {
  DrawerCubit() : super(DrawerInitial());

  void openDrawer(DrawerType type) {
    emit(DrawerOpened(type));
  }

  void closeDrawer() {
    emit(DrawerInitial());
  }
}

enum DrawerType { profile, cart, notifications }
