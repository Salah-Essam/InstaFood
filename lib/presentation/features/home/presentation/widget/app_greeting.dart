import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/presentation/features/home/logic/cubit/greetings_cubit.dart';

class Greetings extends StatefulWidget {
  const Greetings({super.key});

  @override
  State<Greetings> createState() => _GreetingsState();
}

class _GreetingsState extends State<Greetings> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GreetingsCubit()..loadGreetings(),
      child: BlocBuilder<GreetingsCubit, GreetingsState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(state.greeting, style: AppTextStyles.greeting),
              Text(state.dialogue, style: AppTextStyles.greetingDialog),
            ],
          );
        },
      ),
    );
  }
}
