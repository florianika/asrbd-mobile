import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;

  SharedPreferences? _preferences;

  LocalStorageService._internal();

  // Initialize SharedPreferences
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Save String Data
  Future<void> saveString(String key, String value) async {
    await _preferences?.setString(key, value);
  }

  // Get String Data
  String? getString(String key) {
    return _preferences?.getString(key);
  }

  // Save Boolean Data
  Future<void> saveBool(String key, bool value) async {
    await _preferences?.setBool(key, value);
  }

  // Get Boolean Data
  bool getBool(String key) {
    return _preferences?.getBool(key) ?? false;
  }

  // Remove Data
  Future<void> remove(String key) async {
    await _preferences?.remove(key);
  }

  // Clear All Data
  Future<void> clear() async {
    await _preferences?.clear();
  }
}
