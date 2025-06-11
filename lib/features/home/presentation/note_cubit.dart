import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:asrdb/core/services/note_service.dart';
import 'package:asrdb/core/models/note/note_model.dart';

abstract class NoteState {}

class NoteInitial extends NoteState {}

class NoteLoading extends NoteState {}

class NoteLoaded extends NoteState {
  final List<Note> notes;
  NoteLoaded(this.notes);
}

class NotePostSuccess extends NoteState {}

class NoteError extends NoteState {
  final String message;
  NoteError(this.message);
}

class NoteCubit extends Cubit<NoteState> {
  final NoteService noteService;
  NoteCubit(this.noteService) : super(NoteInitial());

  Future<void> getNotes(String buildingGlobalId) async {
    emit(NoteLoading());
    try {
      final result = await noteService.getNotes(buildingGlobalId);
      emit(NoteLoaded(result.notes)); 
    } catch (e) {
      emit(NoteError("Error fetching notes: $e"));
    }
  }

  Future<void> postNote(String buildingGlobalId, String noteText, String createdUser) async {
    emit(NoteLoading());
    try {
      final success = await noteService.postNote(buildingGlobalId, noteText, createdUser);
      if (success) {
        emit(NotePostSuccess());
        await getNotes(buildingGlobalId);
      } else {
        emit(NoteError("Failed to post note"));
      }
    } catch (e) {
      emit(NoteError("Error posting note: $e"));
    }
  }
}
