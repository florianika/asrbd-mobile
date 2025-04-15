import '../user_model.dart';

class AuthResponse {
  final String accessToken;
  final String idToken;
  final String refreshToken;
  final UserModel? user;

  AuthResponse(
      {required this.idToken,
      required this.accessToken,
      required this.refreshToken,      
      this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      idToken: json['idToken'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],      
      user: UserModel.fromIdToken(json['idToken']),
    );
  }
}
