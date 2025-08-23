import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_food/core/router/app_routes.dart';
import 'package:insta_food/presentation/widgets/app_searchBar.dart';

class Searchinkwell extends StatelessWidget {
  const Searchinkwell({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(AppRoutes.search);
      },
      child: searchBar(enabled: false),
    );
  }
}
