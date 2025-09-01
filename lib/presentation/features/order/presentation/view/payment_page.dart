import 'package:flutter/material.dart';
import 'package:insta_food/presentation/widgets/shared_scaffold.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SharedScaffold(
      appBarTitle: 'Payment',
      pageDetails: SizedBox.shrink(),
    );
  }
}
