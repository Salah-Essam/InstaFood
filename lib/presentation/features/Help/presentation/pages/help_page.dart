import 'package:flutter/material.dart';
import 'package:insta_food/presentation/widgets/shared_scaffold.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(appBarTitle: "Help", pageDetails: const SizedBox());
  }
}
