import 'package:asrdb/core/api/auth_api.dart';
import 'package:asrdb/core/models/auth/auth_esri_response.dart';
import 'package:asrdb/core/models/auth/auth_response.dart';
import 'package:asrdb/core/models/auth/auth_response2.dart';
import 'package:asrdb/core/services/auth_service.dart';

class AuthRepository {
  final AuthService authService;
  final AuthApi _authApi;

  AuthRepository(this.authService, this._authApi);

  // Login method
  Future<AuthResponse2> login(String email, String password) async {
    return await authService.login(email, password);
  }

  Future<AuthResponse> verifyOtp(String userId, String otp) async {
    return await authService.verifyOtp(userId, otp);
  }

  Future<AuthEsriResponse> loginEsri() async {
    return await authService.loginEsri();
  }

  Future<void> logout() async {
    return await authService.logout();
  }

  Future<void> forgotPassword(String email) async {
    final response = await _authApi.forgotPassword(email);
    if (response.statusCode != 200) {
      throw Exception('Failed to send password reset email');
    }
  }
}
