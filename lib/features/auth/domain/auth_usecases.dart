import 'package:asrdb/core/models/user_model.dart';
import 'package:asrdb/features/auth/data/auth_repository.dart';

class AuthUseCases {
  final AuthRepository _authRepository;

  AuthUseCases(this._authRepository);

  // Use case for logging in
  Future<UserModel> login(String email, String password) async {
    return await _authRepository.login(email, password);
  }
}
