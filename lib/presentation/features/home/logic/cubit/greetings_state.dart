part of 'greetings_cubit.dart';

sealed class GreetingsState extends Equatable {
  final String greeting;
  final String dialogue;
  const GreetingsState({required this.greeting, required this.dialogue});

  @override
  List<Object> get props => [greeting, dialogue];
}

class GreetingsInitial extends GreetingsState {
  const GreetingsInitial() : super(greeting: '', dialogue: '');
}

class GreetingsLoaded extends GreetingsState {
  const GreetingsLoaded({required super.greeting, required super.dialogue});
}
