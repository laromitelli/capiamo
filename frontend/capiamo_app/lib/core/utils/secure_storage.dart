import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // BASIC AUTH (used for backend authentication)
  static const String keyBasicAuthUsername = 'basic_auth_username';
  static const String keyBasicAuthPassword = 'basic_auth_password';

  // USER PROFILE CACHED EXPORT (used by user_repository.dart)
  static const String keyUserId = 'user_id';
  static const String keyDisplayedName = 'displayed_name';
  static const String keyProfileUri = 'profile_uri';
  static const String keyHideProfilePicture = 'hide_profile_picture';

  /// Write a value
  static Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Read a value
  static Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  /// Delete one key
  static Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// Clear everything (logout)
  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}
