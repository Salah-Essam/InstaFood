import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static SharedPrefsService? _instance;
  static SharedPreferences? _prefs;

  SharedPrefsService._();

  static Future<SharedPrefsService> getInstance() async {
    if (_instance == null) {
      _instance = SharedPrefsService._();
      _prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  // Onboarding related methods
  static const String _keySeenOnboarding = 'seen_onboarding';
  static const String _keyOnboardingStep = 'onboarding_step';
  static const String _keyFirstLaunch = 'first_launch';
  static const String _keySeenSecondSplash = 'seen_second_splash';

  // Check if user has seen onboarding
  Future<bool> hasSeenOnboarding() async {
    return _prefs?.getBool(_keySeenOnboarding) ?? false;
  }

  // Mark onboarding as completed
  Future<void> markOnboardingCompleted() async {
    await _prefs?.setBool(_keySeenOnboarding, true);
  }

  // Check if user has seen second splash screen
  Future<bool> hasSeenSecondSplash() async {
    return _prefs?.getBool(_keySeenSecondSplash) ?? false;
  }

  // Mark second splash as completed
  Future<void> markSecondSplashCompleted() async {
    await _prefs?.setBool(_keySeenSecondSplash, true);
  }

  // Get current onboarding step
  Future<int> getOnboardingStep() async {
    return _prefs?.getInt(_keyOnboardingStep) ?? 0;
  }

  // Set current onboarding step
  Future<void> setOnboardingStep(int step) async {
    await _prefs?.setInt(_keyOnboardingStep, step);
  }

  // Check if it's first launch
  Future<bool> isFirstLaunch() async {
    return _prefs?.getBool(_keyFirstLaunch) ?? true;
  }

  // Mark first launch as completed
  Future<void> markFirstLaunchCompleted() async {
    await _prefs?.setBool(_keyFirstLaunch, false);
  }

  // Clear onboarding data (useful for testing or reset)
  Future<void> clearOnboardingData() async {
    await _prefs?.remove(_keySeenOnboarding);
    await _prefs?.remove(_keyOnboardingStep);
    await _prefs?.remove(_keySeenSecondSplash);
  }

  // Generic methods for other preferences
  Future<T?> getValue<T>(String key, T defaultValue) async {
    if (T == bool) {
      return (_prefs?.getBool(key) ?? defaultValue) as T;
    } else if (T == int) {
      return (_prefs?.getInt(key) ?? defaultValue) as T;
    } else if (T == double) {
      return (_prefs?.getDouble(key) ?? defaultValue) as T;
    } else if (T == String) {
      return (_prefs?.getString(key) ?? defaultValue) as T;
    } else if (T == List<String>) {
      return (_prefs?.getStringList(key) ?? defaultValue) as T;
    }
    return defaultValue;
  }

  Future<void> setValue<T>(String key, T value) async {
    if (value is bool) {
      await _prefs?.setBool(key, value);
    } else if (value is int) {
      await _prefs?.setInt(key, value);
    } else if (value is double) {
      await _prefs?.setDouble(key, value);
    } else if (value is String) {
      await _prefs?.setString(key, value);
    } else if (value is List<String>) {
      await _prefs?.setStringList(key, value);
    }
  }

  Future<void> removeValue(String key) async {
    await _prefs?.remove(key);
  }

  Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
