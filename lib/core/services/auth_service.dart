import 'package:asrdb/core/api/auth_api.dart';
import 'package:asrdb/core/models/user_model.dart';

class AuthService {
  final AuthApi authApi;
  AuthService(this.authApi);
  // Login method
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await authApi.login(email, password);

      // Here you would parse the response and handle tokens, errors, etc.
      if (response.statusCode == 200) {
        return UserModel.fromJson(
            response.data); // Assuming you return user data on successful login
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
}
