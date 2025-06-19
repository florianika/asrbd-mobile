import 'package:asrdb/core/db/hive_boxes.dart';
import 'package:hive/hive.dart';

class StorageService {
  final String _boxName = HiveBoxes.validations;

  // Open box (lazy singleton pattern)
  Future<Box> _getBox(String? box) async {
    if (!Hive.isBoxOpen(box ?? _boxName)) {
      return await Hive.openBox(_boxName);
    }
    return Hive.box(_boxName);
  }

  // Save a string value
  Future<void> saveString(
      {String boxName = HiveBoxes.validations,
      required String key,
      required String value}) async {
    final box = await _getBox(boxName);
    await box.put(key, value);
  }

  Future<void> saveBool(
      {String boxName = HiveBoxes.validations,
      required String key,
      required String value}) async {
    final box = await _getBox(boxName);
    await box.put(key, value);
  }

  // Retrieve a string value
  Future<String?> getString({
    String boxName = HiveBoxes.validations,
    required String key,
  }) async {
    final box = await _getBox(boxName);
    final value = box.get(key);
    return value is String ? value : null;
  }

  // Clear all stored values
  Future<bool> clear({
    String boxName = HiveBoxes.validations,
  }) async {
    final box = await _getBox(boxName);
    await box.clear();
    return true;
  }
}
