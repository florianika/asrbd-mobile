class AuthResponse {
  final String idToken;
  final String accessToken;
  final String refreshToken;

  AuthResponse({
    required this.idToken,
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      idToken: json['idToken'] ?? '', 
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idToken': idToken,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}

