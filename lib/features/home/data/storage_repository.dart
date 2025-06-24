import 'package:asrdb/core/db/hive_boxes.dart';
import 'package:asrdb/core/services/storage_service.dart';

class StorageRepository {
  final StorageService _storageService;

  StorageRepository(this._storageService);

  Future<void> saveString({
    String boxName = HiveBoxes.validations,
    required String key,
    required String value,
  }) async {
    await _storageService.saveString(key: key, value: value);
  }

  Future<String?> getString({
    String boxName = HiveBoxes.validations,
    required String key,
  }) async {
    return _storageService.getString(key: key);
  }

  Future<Map<String, dynamic>?> getMap({
    String boxName = HiveBoxes.validations,
    required String key,
  }) async {
    return _storageService.getMap(key: key);
  }

  Future<void> saveMap({
    String boxName = HiveBoxes.validations,
    required String key,
    required Map<String, dynamic> value,
  }) async {
    _storageService.saveMap(key: key, value: value);
  }

  Future<bool?> clear({
    String boxName = HiveBoxes.validations,
  }) async {
    return await _storageService.clear();
  }

  Future<bool?> containsKey({
    String boxName = HiveBoxes.validations,
    required String key,
  }) async {
    return await _storageService.containsKey(key: key);
  }
}
