import 'package:flutter/material.dart';
import 'package:insta_food/core/theme/app_strings.dart';
import 'package:insta_food/presentation/widgets/app_backbutton.dart';

class TopRow extends StatelessWidget {
  final String title;

  const TopRow({super.key, this.title = AppStrings.login});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Row(
        children: [
          AppBackButton(),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 48), // Balance the back button
        ],
      ),
    );
  }
}
             