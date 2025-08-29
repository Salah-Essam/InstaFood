import 'package:flutter/material.dart';
import 'package:insta_food/core/theme/app_strings.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';

class Greetings extends StatefulWidget {
  const Greetings({super.key});

  @override
  State<Greetings> createState() => _GreetingsState();
}

class _GreetingsState extends State<Greetings> {
  late String greeting;
  late String dialoge;
  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now(); //Gets current time
    //print(now);
    _setGreeting(now);
  }

  // Sets greetings based on time
  void _setGreeting(DateTime now) {
    if (now.hour >= 6 && now.hour < 12) {
      greeting = AppStrings.goodMorining;
      dialoge = AppStrings.morningDialoug;
    } else if (now.hour >= 12 && now.hour < 19) {
      greeting = AppStrings.goodAfternoon;
      dialoge = AppStrings.afternoonDialoug;
    } else {
      greeting = AppStrings.goodEvening;
      dialoge = AppStrings.eveningDialoug;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(greeting, style: AppTextStyles.greeting),
        Text(dialoge, style: AppTextStyles.greetingDialog),
      ],
    );
  }
}
