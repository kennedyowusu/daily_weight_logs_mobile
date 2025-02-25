import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DailyWeightLogsSecureStorage {
  static const _storage = FlutterSecureStorage();
  static const _accessTokenKey = 'access_token';
  static const _userSeenOnboardingKey = 'onboarding_completed';
  static const _userIdKey = 'user_id';

  Future<String> getAccessToken() {
    return _storage.read(key: _accessTokenKey).then((value) => value ?? '');
  }

  Future<void> storeAccessToken(String token) {
    return _storage.write(key: _accessTokenKey, value: token);
  }

  Future<void> deleteAccessToken() {
    return _storage.delete(key: _accessTokenKey);
  }

  Future<bool> isUserLoggedIn() async {
    final String token = await getAccessToken();
    return token.isNotEmpty;
  }

  Future<String?> getUserId() {
    return _storage.read(key: _userIdKey);
  }

  Future<void> storeUserId(String userId) {
    return _storage.write(key: _userIdKey, value: userId);
  }

  Future<void> deleteUserId() {
    return _storage.delete(key: _userIdKey);
  }

  // Onboarding Completed Flag
  Future<bool> isUserSeenOnboarding() {
    return _storage.read(key: _userSeenOnboardingKey).then((value) {
      return value == 'true';
    });
  }

  Future<void> setIsUserSeenOnboarding(bool value) async {
    await _storage.write(
      key: _userSeenOnboardingKey,
      value: value.toString(),
    );
  }
}
