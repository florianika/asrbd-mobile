import 'package:asrdb/features/home/data/note_repository.dart';

class NoteUseCases {
  final NoteRepository _noteRepository;

  NoteUseCases(this._noteRepository);

  Future<bool> getNotes(String buildingGlobalId) async {
    return await _noteRepository.getNotes(buildingGlobalId);
  }

  Future<bool> postNotes(String buildingGlobalId, String noteText, String createdUser) async {
    return await _noteRepository.postNote(buildingGlobalId,noteText,createdUser);
  }
}
