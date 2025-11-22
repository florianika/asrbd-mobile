import 'package:asrdb/core/models/auth/auth_esri_response.dart';
import 'package:asrdb/core/models/auth/auth_response.dart';
import 'package:asrdb/core/models/auth/auth_response2.dart';
import 'package:asrdb/core/services/auth_service.dart';
import 'package:asrdb/core/models/user_model.dart';

class AuthRepository {
  final AuthService authService;

  AuthRepository(this.authService);

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

  Future<bool> isLoggedIn() async {
    return await authService.isLoggedIn();
  }

  Future<String?> getLoggedInUserId() async {
    final idToken = await authService.getUserId();
    if (idToken != null) {
      try {
        final user = UserModel.fromIdToken(idToken);
        return user.id;
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
