import 'package:flutter/material.dart';
import 'package:insta_food/presentation/widgets/custom_appbar.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(inableSearch: true, leading: true),
      body: ListView(),
    );
  }
}
