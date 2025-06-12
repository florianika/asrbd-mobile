import 'package:hive/hive.dart';

class StorageService {
  final String _boxName = 'app_storage';

  // Open box (lazy singleton pattern)
  Future<Box> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox(_boxName);
    }
    return Hive.box(_boxName);
  }

  // Save a string value
  Future<void> saveString(String key, String value) async {
    final box = await _getBox();
    await box.put(key, value);
  }

  // Retrieve a string value
  Future<String?> getString(String key) async {
    final box = await _getBox();
    final value = box.get(key);
    return value is String ? value : null;
  }

  // Clear all stored values
  Future<bool> clear() async {
    final box = await _getBox();
    await box.clear();
    return true;
  }
}
