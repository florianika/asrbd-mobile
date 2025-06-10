import 'package:flutter/material.dart';
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class NotesWidget extends StatefulWidget {
  final ScrollController? scrollController;

  const NotesWidget({super.key, this.scrollController});

  @override
  State<NotesWidget> createState() => _NotesWidgetState();
}

class _NotesWidgetState extends State<NotesWidget> with SingleTickerProviderStateMixin {
  final List<Note> _notes = [];
  final TextEditingController _controller = TextEditingController();

  ScrollController? _internalScrollController;
  late ScrollController _effectiveScrollController;

  bool _isLoading = false;

  late AnimationController _sendButtonAnimationController;
  late Animation<double> _sendButtonScaleAnimation;

  final String getNotesUrl = 'https://544bad0f-a2ef-48ee-a676-f7fae5c413f9.mock.pstmn.io/getsms';
  final String postNoteUrl = 'https://0184fb85-0d16-4405-883f-85d94e728129.mock.pstmn.io/post';

  @override
  void initState() {
    super.initState();
    _fetchNotes();

    if (widget.scrollController != null) {
      _effectiveScrollController = widget.scrollController!;
    } else {
      _internalScrollController = ScrollController();
      _effectiveScrollController = _internalScrollController!;
    }

    _sendButtonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _sendButtonScaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _sendButtonAnimationController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _sendButtonAnimationController.dispose();
    _internalScrollController?.dispose();
    super.dispose();
  }

  Future<void> _fetchNotes() async {
    setState(() {
      _isLoading = true;
    });
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
        debugPrint('Failed to load notes: ${response.statusCode}');
        _showSnackBar('Failed to load notes. Please try again.');
      }
    } catch (e) {
      debugPrint('Error fetching notes: $e');
      _showSnackBar('Error fetching notes. Check your internet connection.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addNote() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      _showSnackBar('Note cannot be empty!');
      return;
    }

    _sendButtonAnimationController.forward().then((_) {
      _sendButtonAnimationController.reverse();
    });

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

    _effectiveScrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );

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
        debugPrint('Failed to post note: ${response.statusCode}');
        _showSnackBar('Failed to send note. Please try again.');
        setState(() {
          _notes.removeAt(0); 
        });
      }
    } catch (e) {
      debugPrint('Error posting note: $e');
      _showSnackBar('Error sending note. Check your internet connection.');
      setState(() {
        _notes.removeAt(0);
      });
    }
  }

  String _formatDate(DateTime timestamp) {
    return DateFormat('MMM dd, yyyy – HH:mm').format(timestamp);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Shenimet e Nderteses",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 8,
        shadowColor: colorScheme.primary.withOpacity(0.4),
      ),
      backgroundColor: colorScheme.surface,
      resizeToAvoidBottomInset: false,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: [
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                shadowColor: colorScheme.primary.withOpacity(0.2),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          maxLines: 5,
                          minLines: 1,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            hintText: 'Shkruaj një shënim rreth kësaj ndërtese...',
                            hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6), fontSize: 15),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                          ),
                          style: TextStyle(color: colorScheme.onSurface, fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 15),
                      ScaleTransition(
                        scale: _sendButtonScaleAnimation,
                        child: FloatingActionButton(
                          onPressed: _addNote,
                          mini: false,
                          backgroundColor: colorScheme.secondary,
                          foregroundColor: colorScheme.onSecondary,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(Icons.send_rounded, size: 28),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Divider(height: 1, color: colorScheme.outline.withOpacity(0.5)),
              const SizedBox(height: 15),
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: colorScheme.primary,
                        ),
                      )
                    : _notes.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.notes,
                                  size: 60,
                                  color: colorScheme.primary.withOpacity(0.4),
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  'Nuk ka shenime per kete ndertese!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: colorScheme.onSurface.withOpacity(0.7),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            controller: _effectiveScrollController,
                            itemCount: _notes.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              final note = _notes[index];
                              return NoteCard(note: note, formatDate: _formatDate, colorScheme: colorScheme);
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

class NoteCard extends StatelessWidget {
  final Note note;
  final Function(DateTime) formatDate;
  final ColorScheme colorScheme;

  const NoteCard({
    super.key,
    required this.note,
    required this.formatDate,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      shadowColor: Colors.black.withOpacity(0.15),
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.noteText,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                'By ${note.createdUser} on ${formatDate(note.createdTimestamp)}',
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurface.withOpacity(0.7),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
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