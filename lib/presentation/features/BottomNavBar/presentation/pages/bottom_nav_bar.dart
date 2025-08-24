import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/presentation/features/BottomNavBar/presentation/cubit/drawer_cubit.dart';
import 'package:insta_food/presentation/features/BottomNavBar/presentation/pages/app_drawer.dart';
import 'package:insta_food/presentation/features/home/presentation/home_page.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  List<PersistentTabConfig> _tabs() {
    return [
      PersistentTabConfig(
        screen: HomePage(
          // scaffoldKey: _scaffoldKey,
          // openDrawerCallback: (DrawerCubit cubit, DrawerType type) {
          //   cubit.getDrawerData(type);
          // },
        ),
        item: ItemConfig(
          icon: SvgPicture.asset(
            "assets/icons/Home.svg",
            colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          inactiveIcon: SvgPicture.asset("assets/icons/Home.svg"),
        ),
      ),
      PersistentTabConfig(
        screen: Page(name: 'Menu', scaffoldKey: _scaffoldKey),
        item: ItemConfig(
          icon: SvgPicture.asset(
            "assets/icons/Menu.svg",
            colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          inactiveIcon: SvgPicture.asset("assets/icons/Menu.svg"),
        ),
      ),
      PersistentTabConfig(
        screen: Page(name: 'Favorites', scaffoldKey: _scaffoldKey),
        item: ItemConfig(
          icon: SvgPicture.asset(
            "assets/icons/fav.svg",
            colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          inactiveIcon: SvgPicture.asset("assets/icons/fav.svg"),
        ),
      ),
      PersistentTabConfig(
        screen: Page(name: 'Orders', scaffoldKey: _scaffoldKey),
        item: ItemConfig(
          icon: SvgPicture.asset(
            "assets/icons/order.svg",
            colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          inactiveIcon: SvgPicture.asset("assets/icons/order.svg"),
        ),
      ),
      PersistentTabConfig(
        screen: Page(name: 'Help', scaffoldKey: _scaffoldKey),
        item: ItemConfig(
          icon: SvgPicture.asset(
            "assets/icons/help.svg",
            colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          inactiveIcon: SvgPicture.asset("assets/icons/help.svg"),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = DrawerCubit();

        return cubit;
      },
      child: BlocBuilder<DrawerCubit, DrawerState>(
        builder: (context, drawerContent) {
          return Scaffold(
            key: _scaffoldKey,
            endDrawer: AppDrawer(
              drawerContent: drawerContent is ShowProfileDrawer
                  ? drawerContent.profileDrawer
                  : drawerContent is ShowCartDrawer
                  ? drawerContent.cartDrawer
                  : drawerContent is ShowNotificationsDrawer
                  ? drawerContent.notificationsDrawer
                  : Center(child: Text("No Data")),
            ),
            body: PersistentTabView(
              tabs: _tabs(),

              screenTransitionAnimation: ScreenTransitionAnimation(
                curve: Curves.ease,
                duration: Duration(milliseconds: 300),
              ),
              navBarBuilder: (p0) => NeumorphicBottomNavBar(
                navBarConfig: p0,

                navBarDecoration: NavBarDecoration(
                  color: AppColors.orangeBase,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Page extends StatelessWidget {
  const Page({super.key, required this.name, this.scaffoldKey});
  final GlobalKey<ScaffoldState>? scaffoldKey;

  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('InstaFood'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            iconSize: 24,
            onPressed: () {
              scaffoldKey?.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      body: Center(child: Text(name)),
    );
  }
}
