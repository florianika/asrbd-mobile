import 'dart:convert';
import 'package:asrdb/core/models/note/note_model.dart';

class NoteApiResponse {
  final List<Note> notes;

  const NoteApiResponse({required this.notes});

   factory NoteApiResponse.fromJson(Map<String, dynamic> json) {
    final notesJson = json['notesDTO'] as List<dynamic>;
    final notes = notesJson
        .map((item) => Note.fromJson(item as Map<String, dynamic>))
        .toList();
    return NoteApiResponse(notes: notes);
  }

  static List<Note> parseNotes(dynamic json) {
    if (json is String) {
      json = jsonDecode(json);
    }
    final notesJson = json['notesDTO'] as List<dynamic>;
    return notesJson
        .map((item) => Note.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
