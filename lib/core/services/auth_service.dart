import 'package:asrdb/core/api/auth_api.dart';
import 'package:asrdb/core/models/auth_response.dart';


class AuthService {
  final AuthApi authApi;

  AuthService(this.authApi);

  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await authApi.login(email, password);

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(response.data);
      } else {
        String errorMessage = 'Server Error: ${response.statusCode}';

        if (response.data is Map<String, dynamic> && response.data.containsKey('message')) {
          errorMessage = response.data['message'];
        }

        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}