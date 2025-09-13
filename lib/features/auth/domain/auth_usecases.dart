import 'package:asrdb/core/models/auth/auth_response.dart';
import 'package:asrdb/features/auth/data/auth_repository.dart';
import 'package:asrdb/features/home/data/storage_repository.dart';

class AuthUseCases {
  final AuthRepository _authRepository;
  final StorageRepository _storageRepository;

  AuthUseCases(this._authRepository, this._storageRepository);

  // Use case for logging in
  Future<AuthResponse> login(String email, String password) async {
    await _storageRepository.clear();
    AuthResponse authResponse = await _authRepository.login(email, password);
    await _authRepository.loginEsri();

    return authResponse;
  }

  // Use case for logging out
  Future<void> logout() async {
    await _authRepository.logout();
    await _storageRepository.clear();
  }
}
