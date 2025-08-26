import 'package:insta_food/core/storage/shared_prefrences/shared_prefs_service.dart';

class OnboardingService {
  final SharedPrefsService _prefsService;

  OnboardingService(this._prefsService);

  // Check if user should see onboarding
  Future<bool> shouldShowOnboarding() async {
    return !(await _prefsService.hasSeenOnboarding());
  }

  // Mark onboarding as completed
  Future<void> completeOnboarding() async {
    await _prefsService.markOnboardingCompleted();
    await _prefsService.setOnboardingStep(2);
  }

  // Get current onboarding step
  Future<int> getCurrentStep() async {
    return await _prefsService.getOnboardingStep();
  }

  // Set current onboarding step
  Future<void> setCurrentStep(int step) async {
    await _prefsService.setOnboardingStep(step);
  }

  // Reset onboarding (useful for testing)
  Future<void> resetOnboarding() async {
    await _prefsService.clearOnboardingData();
  }

  // Check if it's first launch
  Future<bool> isFirstLaunch() async {
    return await _prefsService.isFirstLaunch();
  }

  // Mark first launch as completed
  Future<void> markFirstLaunchCompleted() async {
    await _prefsService.markFirstLaunchCompleted();
  }
}
