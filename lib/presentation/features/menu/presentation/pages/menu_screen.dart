import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_food/presentation/features/menu/presentation/cubit/menu_cubit.dart';
import 'package:insta_food/presentation/features/menu/presentation/cubit/menu_cubit_state.dart';
import 'package:insta_food/presentation/features/menu/presentation/widgets/menu_category_bar.dart';
import 'package:insta_food/presentation/features/menu/presentation/widgets/menu_item_card.dart';
import 'package:insta_food/presentation/features/menu/presentation/widgets/price_filter_icon.dart';
import 'package:insta_food/presentation/widgets/shared_scaffold.dart';
import 'package:insta_food/presentation/features/Restaurants/data/model/restaurant_model.dart';
import 'package:insta_food/core/constants/menu_constants.dart';

class MenuPage extends StatefulWidget {
  final Restaurant? restaurant;
  const MenuPage({super.key, this.restaurant});

  @override
  State<MenuPage> createState() => MenuPageState();
}

class MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SharedScaffold(
        appBarTitle: widget.restaurant?.restaurantName ?? 'Menu',
        contentPadding: const EdgeInsets.fromLTRB(25, 12, 25, 16),
        headerAction: const PriceFilterIcon(),
        pageDetails: BlocBuilder<MenuCubit, MenuState>(
          builder: (context, state) {
            if (state is MenuLoading || state is MenuInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is MenuError) {
              return Center(child: Text(state.message));
            }
            final loaded = state as MenuLoaded;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MenuCategoryBar(
                  categories: MenuConstants.categories,
                  active: loaded.activeCategory,
                  onSelect: (cat) => context.read<MenuCubit>().filterByCategory(cat),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: loaded.visibleItems.isEmpty
                      ? const Center(child: Text('No items'))
                      : ListView.separated(
                          padding: const EdgeInsets.only(bottom: 16, top: 4),
                          itemCount: loaded.visibleItems.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (ctx, i) => MenuItemCard(item: loaded.visibleItems[i]),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}