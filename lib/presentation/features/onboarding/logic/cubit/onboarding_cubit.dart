import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:insta_food/core/storage/shared_prefrences/shared_prefs_service.dart';
import '../services/onboarding_service.dart';
import '../constants/onboarding_constants.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final PageController pageController = PageController();
  late final OnboardingService _onboardingService;

  OnboardingCubit() : super(const OnboardingState(index: 0)) {
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    final prefsService = await SharedPrefsService.getInstance();
    _onboardingService = OnboardingService(prefsService);
  }

  void onPageChanged(int i) => emit(state.copyWith(index: i));

  Future<bool> next() async {
    final last = state.index >= OnboardingConstants.lastPageIndex;
    if (last) {
      await _complete();
      return true;
    } else {
      await pageController.nextPage(
        duration: OnboardingConstants.pageTransitionDuration,
        curve: Curves.easeOut,
      );
      return false;
    }
  }

  void skip() {
    pageController.animateToPage(
      OnboardingConstants.lastPageIndex,
      duration: OnboardingConstants.pageTransitionDuration,
      curve: Curves.easeOut,
    );
  }

  void goTo(int target) {
    if (target == state.index) return;
    pageController.animateToPage(
      target,
      duration: OnboardingConstants.pageTransitionDuration,
      curve: Curves.easeOut,
    );
  }

  Future<void> _complete() async {
    await _onboardingService.completeOnboarding();
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
