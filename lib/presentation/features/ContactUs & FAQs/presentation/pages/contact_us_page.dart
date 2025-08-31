import 'package:flutter/material.dart';
import 'package:insta_food/presentation/widgets/shared_scaffold.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      appBarTitle: "Contac Us",
      pageDetails: const SizedBox(),
    );
  }
}
