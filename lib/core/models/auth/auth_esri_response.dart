class AuthEsriResponse {
  final String accessToken;
  final int? expires; // Expiration timestamp or duration in seconds

  AuthEsriResponse({
    required this.accessToken,
    this.expires,
  });

  factory AuthEsriResponse.fromJson(Map<String, dynamic> json) {
    return AuthEsriResponse(
      accessToken: json['token'],
      expires: json['expires'], // Adjust key if actual API differs
    );
  }
}
