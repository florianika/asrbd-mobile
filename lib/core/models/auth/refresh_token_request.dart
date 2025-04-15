class RefreshTokenRequest {
  final String accessToken;
  final String refreshToken;

  RefreshTokenRequest({
    required this.accessToken,
    required this.refreshToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}
