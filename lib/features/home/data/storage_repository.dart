import 'package:asrdb/core/services/storage_service.dart';

class StorageRepository {
  final StorageService _storageService;

  StorageRepository(this._storageService);

  Future<void> saveString(String key, String value) async {
    await _storageService.saveString(key, value);
  }

  Future<String?> getString(String key) async {
    return _storageService.getString(key);
  }

  Future<bool?> clear() async {
    return await _storageService.clear();
  }


}
