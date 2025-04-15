import 'package:asrdb/core/api/auth_api.dart';
import 'package:asrdb/core/local_storage/storage_keys.dart';
import 'package:asrdb/core/models/auth/auth_esri_response.dart';
import 'package:asrdb/core/models/auth/auth_response.dart';
import 'package:asrdb/core/models/auth/refresh_token_request.dart';
import 'package:asrdb/core/services/storage_service.dart';

class AuthService {
  final AuthApi authApi;
  AuthService(this.authApi);
  final StorageService _storage = StorageService();

  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await authApi.login(email, password);

      // Here you would parse the response and handle tokens, errors, etc.
      if (response.statusCode == 200) {
        AuthResponse authResponse = AuthResponse.fromJson(response.data);
        await _storage.saveString(
            StorageKeys.accessToken, authResponse.accessToken);
        await _storage.saveString(
            StorageKeys.refreshToken, authResponse.refreshToken);
        await _storage.saveString(StorageKeys.idhToken, authResponse.idToken);

        return authResponse;
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<AuthEsriResponse> loginEsri() async {
    try {
      String? accessToken = await _storage.getString(StorageKeys.accessToken);
      if (accessToken == null) throw Exception('Failed to login');

      final response = await authApi.loginEsri(accessToken);

      // Here you would parse the response and handle tokens, errors, etc.
      if (response.statusCode == 200) {
        AuthEsriResponse authResponse =
            AuthEsriResponse.fromJson(response.data);
        await _storage.saveString(
            StorageKeys.esriAccessToken, authResponse.accessToken);

        return authResponse;
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<AuthResponse> refreshToken() async {
    try {
      String? refreshToken = await _storage.getString(StorageKeys.refreshToken);
      String? accessToken = await _storage.getString(StorageKeys.accessToken);
      if (refreshToken == null || accessToken == null) {
        throw Exception('Failed login');
      }

      RefreshTokenRequest refreshTokenREquest = RefreshTokenRequest(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      final response = await authApi.refreshToken(refreshTokenREquest);

      if (response.statusCode == 200) {
        AuthResponse authResponse = AuthResponse.fromJson(response.data);
        await _storage.saveString(
            StorageKeys.accessToken, authResponse.accessToken);
        await _storage.saveString(
            StorageKeys.refreshToken, authResponse.refreshToken);
        await _storage.saveString(StorageKeys.idhToken, authResponse.idToken);

        final esriResponse = await authApi.loginEsri(accessToken);
        if (esriResponse.statusCode == 200) {
          AuthEsriResponse authResponse =
              AuthEsriResponse.fromJson(response.data);
          await _storage.saveString(
              StorageKeys.esriAccessToken, authResponse.accessToken);
        }
        return authResponse;
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
}
