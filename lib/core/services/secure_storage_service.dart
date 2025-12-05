import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure storage service for sensitive data like tokens
/// Uses platform-specific secure storage (Keychain on iOS, KeyStore on Android)
class SecureStorageService {
  static final SecureStorageService _instance =
      SecureStorageService._internal();

  factory SecureStorageService() => _instance;

  SecureStorageService._internal();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  /// Save a string value securely
  Future<void> saveString({
    required String key,
    required String value,
  }) async {
    await _secureStorage.write(key: key, value: value);
  }

  /// Get a string value from secure storage
  Future<String?> getString({required String key}) async {
    return await _secureStorage.read(key: key);
  }

  /// Check if a key exists in secure storage
  Future<bool> containsKey({required String key}) async {
    return await _secureStorage.containsKey(key: key);
  }

  /// Remove a specific key from secure storage
  Future<void> remove({required String key}) async {
    await _secureStorage.delete(key: key);
  }

  /// Clear all values from secure storage
  Future<void> clear() async {
    await _secureStorage.deleteAll();
  }

  /// Read all keys and values (useful for debugging)
  Future<Map<String, String>> readAll() async {
    return await _secureStorage.readAll();
  }
}
