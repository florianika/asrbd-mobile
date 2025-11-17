class AuthResponse2 {
  final String userId;
  final String message;

  AuthResponse2({
    required this.userId,
    required this.message,
  });

  factory AuthResponse2.fromJson(Map<String, dynamic> json) {
    return AuthResponse2(
      userId: json['userId'],
      message: json['message'],
    );
  }
}
