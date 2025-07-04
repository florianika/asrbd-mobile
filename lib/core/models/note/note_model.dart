class Note {
  final int noteId;
  final String bldId;
  final String noteText;
  final String createdUser;
  final DateTime createdTimestamp;
   final String userId;

  Note({
    required this.noteId,
    required this.bldId,
    required this.noteText,
    required this.createdUser,
    required this.createdTimestamp,
    required this.userId,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      noteId: json['noteId'],
      bldId: json['bldId'],
      noteText: json['noteText'],
      createdUser: json['createdUser'],
      createdTimestamp: DateTime.parse(json['createdTimestamp']),
      userId: json['userId'],
    );
  }
}
