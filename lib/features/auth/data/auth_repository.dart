import 'package:asrdb/core/models/auth/auth_esri_response.dart';
import 'package:asrdb/core/models/auth/auth_response.dart';
import 'package:asrdb/core/services/auth_service.dart';

class AuthRepository {
  final AuthService authService;

  AuthRepository(this.authService);

  // Login method
  Future<AuthResponse> login(String email, String password) async {
    return await authService.login(email, password);
  }

  Future<AuthEsriResponse> loginEsri() async {
    return await authService.loginEsri();
  }
}
