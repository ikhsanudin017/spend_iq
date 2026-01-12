import 'package:shared_preferences/shared_preferences.dart';

/// Local Authentication Data Source
/// Menyimpan user preferences dan onboarding status
class AuthLocalDatasource {
  static const String _keyHasCompletedOnboarding = 'has_completed_onboarding';
  static const String _keyUserId = 'user_id';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  /// Check if user has completed onboarding
  Future<bool> hasCompletedOnboarding(String userId) async {
    final prefs = await _prefs;
    return prefs.getBool('${_keyHasCompletedOnboarding}_$userId') ?? false;
  }

  /// Set onboarding completed
  Future<void> setOnboardingCompleted(String userId) async {
    final prefs = await _prefs;
    await prefs.setBool('${_keyHasCompletedOnboarding}_$userId', true);
  }

  /// Save last logged in user ID
  Future<void> saveLastUserId(String userId) async {
    final prefs = await _prefs;
    await prefs.setString(_keyUserId, userId);
  }

  /// Get last logged in user ID
  Future<String?> getLastUserId() async {
    final prefs = await _prefs;
    return prefs.getString(_keyUserId);
  }

  /// Clear all auth data
  Future<void> clearAuthData() async {
    final prefs = await _prefs;
    await prefs.remove(_keyUserId);
    // Note: We keep onboarding status per user
  }
}











