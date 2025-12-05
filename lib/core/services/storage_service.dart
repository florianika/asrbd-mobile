import 'package:asrdb/core/db/hive_boxes.dart';
import 'package:asrdb/core/local_storage/storage_keys.dart';
import 'package:asrdb/core/services/secure_storage_service.dart';
import 'package:hive/hive.dart';

class StorageService {
  final String _boxName = HiveBoxes.validations;
  final SecureStorageService _secureStorage = SecureStorageService();

  // List of sensitive keys that should be stored securely
  static const List<String> _sensitiveKeys = [
    StorageKeys.accessToken,
    StorageKeys.refreshToken,
    StorageKeys.idhToken,
    StorageKeys.esriAccessToken,
  ];

  Future<Box> _getBox(String? box) async {
    if (!Hive.isBoxOpen(box ?? _boxName)) {
      return await Hive.openBox(_boxName);
    }
    return Hive.box(_boxName);
  }

  Future<void> saveString(
      {String boxName = HiveBoxes.validations,
      required String key,
      required String value}) async {
    // Use secure storage for sensitive data
    if (_sensitiveKeys.contains(key)) {
      await _secureStorage.saveString(key: key, value: value);
    } else {
      final box = await _getBox(boxName);
      await box.put(key, value);
    }
  }

  Future<void> saveMap(
      {String boxName = HiveBoxes.validations,
      required String key,
      required Map<String, dynamic> value}) async {
    final box = await _getBox(boxName);
    await box.put(key, value);
  }

Future<Map<String, dynamic>> getMap({
  String boxName = HiveBoxes.validations,
  required String key,
}) async {
  final box = await _getBox(boxName);
  final result = await box.get(key);
  return Map<String, dynamic>.from(result ?? {});
}

  Future<void> saveBool(
      {String boxName = HiveBoxes.validations,
      required String key,
      required String value}) async {
    final box = await _getBox(boxName);
    await box.put(key, value);
  }

  Future<String?> getString({
    String boxName = HiveBoxes.validations,
    required String key,
  }) async {
    // Use secure storage for sensitive data
    if (_sensitiveKeys.contains(key)) {
      return await _secureStorage.getString(key: key);
    } else {
      final box = await _getBox(boxName);
      final value = box.get(key);
      return value is String ? value : null;
    }
  }

  Future<bool> containsKey({
    String boxName = HiveBoxes.validations,
    required String key,
  }) async {
    // Use secure storage for sensitive data
    if (_sensitiveKeys.contains(key)) {
      return await _secureStorage.containsKey(key: key);
    } else {
      final box = await _getBox(boxName);
      return box.containsKey(key);
    }
  }

  // Remove a specific key
  Future<void> remove({
    String boxName = HiveBoxes.validations,
    required String key,
  }) async {
    // Use secure storage for sensitive data
    if (_sensitiveKeys.contains(key)) {
      await _secureStorage.remove(key: key);
    } else {
      final box = await _getBox(boxName);
      await box.delete(key);
    }
  }

  // Clear all stored values
  Future<bool> clear({
    String boxName = HiveBoxes.validations,
  }) async {
    // Clear both secure storage (for tokens) and Hive (for other data)
    await _secureStorage.clear();
    final box = await _getBox(boxName);
    await box.clear();
    return true;
  }
}
