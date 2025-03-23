import 'package:asrdb/core/models/auth_response.dart';
import 'package:asrdb/core/services/auth_service.dart';

class AuthRepository {
  final AuthService authService;

  AuthRepository(this.authService);

  Future<AuthResponse> login(String email, String password) async {
    final response = await authService.login(email, password);
    return AuthResponse.fromJson(response.toJson());
  }
}
