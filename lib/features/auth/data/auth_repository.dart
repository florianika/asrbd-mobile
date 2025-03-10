import 'package:asrdb/core/models/user_model.dart';
import 'package:asrdb/core/services/auth_service.dart';

class AuthRepository {
  final AuthService authService;

  AuthRepository(this.authService);

  // Login method
  Future<UserModel> login(String email, String password) async {
    return await authService.login(email, password);
  }
}
