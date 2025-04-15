class AuthEsriResponse {
  final String accessToken;

  AuthEsriResponse({
    required this.accessToken,
  });

  factory AuthEsriResponse.fromJson(Map<String, dynamic> json) {
    return AuthEsriResponse(
      accessToken: json['token'],
    );
  }
}
