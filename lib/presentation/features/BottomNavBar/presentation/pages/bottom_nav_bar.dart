import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/presentation/features/drawer/presentation/cubit/drawer_cubit.dart';
import 'package:insta_food/presentation/features/drawer/presentation/view/app_drawer.dart';
import 'package:insta_food/presentation/features/home/presentation/view/home_page.dart';
import 'package:insta_food/presentation/features/order/presentation/view/my_orders_page.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  List<PersistentTabConfig> _tabs() {
    return [
      PersistentTabConfig(
        screen: HomePage(),
        item: ItemConfig(
          icon: SvgPicture.asset(
            AppAssets.navBarHome,
            colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          inactiveIcon: SvgPicture.asset(AppAssets.navBarHome),
        ),
      ),
      PersistentTabConfig(
        screen: Page(name: 'Menu', scaffoldKey: _scaffoldKey),
        item: ItemConfig(
          icon: SvgPicture.asset(
            AppAssets.navBarMenu,
            colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          inactiveIcon: SvgPicture.asset(AppAssets.navBarMenu),
        ),
      ),
      PersistentTabConfig(
        screen: Page(name: 'Favorites', scaffoldKey: _scaffoldKey),
        item: ItemConfig(
          icon: SvgPicture.asset(
            AppAssets.navBarFav,
            colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          inactiveIcon: SvgPicture.asset(AppAssets.navBarFav),
        ),
      ),
      PersistentTabConfig(
  screen: const MyOrdersPage(),
        item: ItemConfig(
          icon: SvgPicture.asset(
            AppAssets.navBarOrders,
            colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          inactiveIcon: SvgPicture.asset(AppAssets.navBarOrders),
        ),
      ),
      PersistentTabConfig(
        screen: Page(name: 'Help', scaffoldKey: _scaffoldKey),
        item: ItemConfig(
          icon: SvgPicture.asset(
            AppAssets.navBarHelp,
            colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          inactiveIcon: SvgPicture.asset(AppAssets.navBarHelp),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DrawerCubit, DrawerState>(
      listener: (context, state) {
        if (state is DrawerOpened) {
          _scaffoldKey.currentState?.openEndDrawer();
        } else if (state is DrawerInitial) {
          _scaffoldKey.currentState?.closeEndDrawer();
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: BlocBuilder<DrawerCubit, DrawerState>(
          builder: (context, state) {
            if (state is DrawerOpened) {
              return AppDrawer(drawerSelected: state.type);
            }
            return AppDrawer();
          },
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
              color: AppColors.primaryOrange,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
          ),
        ),
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
