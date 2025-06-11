import 'package:asrdb/core/api/note_api.dart';
import 'package:asrdb/core/local_storage/storage_keys.dart';
import 'package:asrdb/core/services/storage_service.dart';

class NoteService {
  final NoteApi noteApi;
  NoteService(this.noteApi);

  final StorageService _storage = StorageService();

  Future<bool> getNotes(String buildingGlobalId) async {
    try {
      String? accessToken = await _storage.getString(StorageKeys.accessToken);

      if (accessToken == null) throw Exception('Login failed:');

      final response =
          await noteApi.getNotes(accessToken, buildingGlobalId);
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<bool> postNote(String buildingGlobalId, String noteText, String createdUser) async {
    try {
      String? accessToken = await _storage.getString(StorageKeys.accessToken);

      if (accessToken == null) throw Exception('Login failed:');

      final response =
          await noteApi.postNote(accessToken, buildingGlobalId,noteText,createdUser);
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
}
