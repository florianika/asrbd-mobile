import 'package:asrdb/core/models/note/note_response.dart';
import 'package:asrdb/core/services/note_service.dart';

class NoteRepository {
  final NoteService noteService;

  NoteRepository(this.noteService);

  Future<NoteApiResponse> getNotes(String buildingGlobalId) async {
    return await noteService.getNotes(buildingGlobalId);
  }

  Future<bool> postNote(String buildingGlobalId, String noteText, String createdUser,String userId) async {
    return await noteService.postNote(buildingGlobalId,noteText,createdUser,userId);
  }
}
