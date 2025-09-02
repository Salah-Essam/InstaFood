import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class BottomNavController {
  BottomNavController._();

  static final PersistentTabController controller =
      PersistentTabController(initialIndex: 0);

  static void switchTo(int index) {
    try {
      controller.jumpToTab(index);
    } catch (_) {}
  }
}
