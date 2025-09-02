import 'package:asrdb/core/db/hive_boxes.dart';
import 'package:hive/hive.dart';

class StorageService {
  final String _boxName = HiveBoxes.validations;

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
    final box = await _getBox(boxName);
    await box.put(key, value);
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
    final box = await _getBox(boxName);
    final value = box.get(key);
    return value is String ? value : null;
  }

  Future<bool> containsKey({
    String boxName = HiveBoxes.validations,
    required String key,
  }) async {
    final box = await _getBox(boxName);
    final value = box.containsKey(key);
    return value;
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
