import 'package:flutter/material.dart';
import 'package:insta_food/presentation/widgets/shared_scaffold.dart';

class HelpFAQsPage extends StatelessWidget {
  const HelpFAQsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      appBarTitle: "Help & FAQs",
      pageDetails: const SizedBox(),
    );
  }
}
