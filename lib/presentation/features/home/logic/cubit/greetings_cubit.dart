import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:insta_food/core/utils/app_strings.dart';

part 'greetings_state.dart';

class GreetingsCubit extends Cubit<GreetingsState> {
  GreetingsCubit() : super(GreetingsInitial()) {
    loadGreetings();
  }
  loadGreetings() {
    final now = DateTime.now();
    final (greeting, dialouge) = _getGreetingData(now);
    emit(GreetingsLoaded(greeting: greeting, dialogue: dialouge));
  }

  (String, String) _getGreetingData(DateTime now) {
    if (now.hour >= 6 && now.hour < 12) {
      return (AppStrings.goodMorining, AppStrings.morningDialoug);
    } else if (now.hour >= 12 && now.hour < 19) {
      return (AppStrings.goodAfternoon, AppStrings.afternoonDialoug);
    } else {
      return (AppStrings.goodEvening, AppStrings.eveningDialoug);
    }
  }
}
