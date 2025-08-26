import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_food/core/routes/router_constants.dart';

class Searchinkwell extends StatelessWidget {
  const Searchinkwell({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(RouterConstants.search);
      },
      child: SizedBox(height: 25, width: 230, child: SearchBar(enabled: false)),
    );
  }
}
