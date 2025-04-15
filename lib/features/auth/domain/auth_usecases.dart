import 'package:asrdb/core/models/auth/auth_response.dart';
import 'package:asrdb/features/auth/data/auth_repository.dart';

class AuthUseCases {
  final AuthRepository _authRepository;

  AuthUseCases(this._authRepository);

  // Use case for logging in
  Future<AuthResponse> login(String email, String password) async {
    AuthResponse authResponse = await _authRepository.login(email, password);
    await _authRepository.loginEsri();

    return authResponse;
  }
}
