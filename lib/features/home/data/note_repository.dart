import 'package:asrdb/core/services/note_service.dart';

class NoteRepository {
  final NoteService noteService;

  NoteRepository(this.noteService);

  Future<bool> getNotes(String buildingGlobalId) async {
    return await noteService.getNotes(buildingGlobalId);
  }

  Future<bool> postNote(String buildingGlobalId, String noteText, String createdUser) async {
    return await noteService.postNote(buildingGlobalId,noteText,createdUser);
  }
}
