// core/services/storage_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // Save a value in SharedPreferences
  Future<void> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  // Retrieve a value from SharedPreferences
  Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  // Other methods for storing data like int, bool, etc.
}
