import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final PageController pageController = PageController();
  static const String keySeenOnboarding = 'seen_onboarding';

  OnboardingCubit() : super(const OnboardingState(index: 0));

  void onPageChanged(int i) => emit(state.copyWith(index: i));

  Future<bool> next() async {
    final last = state.index >= 2;
    if (last) {
      await _complete();
      return true;
    } else {
      await pageController.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.easeOut);
      return false;
    }
  }

  void skip() {
    pageController.animateToPage(2, duration: const Duration(milliseconds: 350), curve: Curves.easeOut);
  }

  void goTo(int target) {
    if (target == state.index) return;
    pageController.animateToPage(target, duration: const Duration(milliseconds: 350), curve: Curves.easeOut);
  }

  Future<void> _complete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keySeenOnboarding, true);
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
