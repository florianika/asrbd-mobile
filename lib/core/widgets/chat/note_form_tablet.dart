import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // For timestamp formatting

class NotesWidget extends StatefulWidget {
  const NotesWidget({super.key});

  @override
  State<NotesWidget> createState() => _NotesWidgetState();
}

class _NotesWidgetState extends State<NotesWidget> {
  final List<Note> _notes = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final String getNotesUrl =
      'https://544bad0f-a2ef-48ee-a676-f7fae5c413f9.mock.pstmn.io/getsms';
  final String postNoteUrl = 'https://your-api.com/post-comment';

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  Future<void> _fetchNotes() async {
    try {
      final response = await http.get(Uri.parse(getNotesUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _notes.clear();
          _notes.addAll(data.map((item) => Note.fromJson(item)));
          _notes.sort((a, b) => b.createdTimestamp.compareTo(a.createdTimestamp));
        });
      } else {
        debugPrint('Failed to load notes');
      }
    } catch (e) {
      debugPrint('Error fetching notes: $e');
    }
  }

  Future<void> _addNote() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final now = DateTime.now();
    final newNote = Note(
      noteId: -1,
      bldId: 'demo-id',
      noteText: text,
      createdUser: 'You',
      createdTimestamp: now,
    );

    setState(() {
      _notes.insert(0, newNote);
      _controller.clear();
    });

    try {
      final response = await http.post(
        Uri.parse(postNoteUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'NoteText': text,
          'CreatedUser': 'You',
          'CreatedTimestamp': now.toIso8601String(),
        }),
      );

      if (response.statusCode != 200) {
        debugPrint('Failed to post note');
      }
    } catch (e) {
      debugPrint('Error posting note: $e');
    }
  }

  String _formatDate(DateTime timestamp) {
    return DateFormat('yyyy-MM-dd – kk:mm').format(timestamp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Building Notes")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Add a note...',
                        contentPadding: const EdgeInsets.all(16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _addNote,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 24,
                      ),
                    ),
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _notes.length,
                  itemBuilder: (context, index) {
                    final note = _notes[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: const Icon(Icons.note_alt_outlined),
                        title: Text(note.noteText),
                        subtitle: Text(
                          'By ${note.createdUser} on ${_formatDate(note.createdTimestamp)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Note {
  final int noteId;
  final String bldId;
  final String noteText;
  final String createdUser;
  final DateTime createdTimestamp;

  Note({
    required this.noteId,
    required this.bldId,
    required this.noteText,
    required this.createdUser,
    required this.createdTimestamp,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      noteId: json['NoteId'],
      bldId: json['BldId'],
      noteText: json['NoteText'],
      createdUser: json['CreatedUser'],
      createdTimestamp: DateTime.parse(json['CreatedTimestamp']),
    );
  }
}
