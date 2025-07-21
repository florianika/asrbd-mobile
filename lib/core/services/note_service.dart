import 'package:asrdb/core/api/note_api.dart';
import 'package:asrdb/core/local_storage/storage_keys.dart';
import 'package:asrdb/core/models/note/note_response.dart';
import 'package:asrdb/core/services/storage_service.dart';

class NoteService {
  final NoteApi noteApi;
  NoteService(this.noteApi);

  final StorageService _storage = StorageService();

  Future<NoteApiResponse> getNotes(String buildingGlobalId) async {
    try {
      String? accessToken =
          await _storage.getString(key: StorageKeys.accessToken);
      if (accessToken == null) throw Exception('Access token missing');
      final response = await noteApi.getNotes(accessToken, buildingGlobalId);
      if (response.statusCode == 200) {
        return NoteApiResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch notes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching notes: $e');
    }
  }

  Future<bool> postNote(String buildingGlobalId, String noteText,
      String createdUser, String userId) async {
    try {
      String? accessToken =
          await _storage.getString(key: StorageKeys.accessToken);
      if (accessToken == null) throw Exception('Access token missing');
      final response = await noteApi.postNote(
          accessToken, buildingGlobalId, noteText, createdUser, userId);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['noteId'] != null) {
          return true;
        }
      }
      return false;
    } catch (e) {
      throw Exception('Error posting note: $e');
    }
  }
}
