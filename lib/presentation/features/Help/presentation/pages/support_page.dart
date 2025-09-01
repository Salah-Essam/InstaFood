import 'package:flutter/material.dart';
import 'package:insta_food/presentation/widgets/shared_scaffold.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      appBarTitle: "Support",
      pageDetails: const SizedBox(),
    );
  }
}
