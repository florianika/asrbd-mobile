import 'package:asrdb/core/models/auth_response.dart';
import 'package:asrdb/features/auth/data/auth_repository.dart';

class AuthUseCases {
  final AuthRepository _authRepository;

  AuthUseCases(this._authRepository);

  Future<AuthResponse> login(String email, String password) async {
    return await _authRepository.login(email, password); 
  }
}
