import 'package:asrdb/core/api/auth_api.dart';
import 'package:asrdb/core/local_storage/storage_keys.dart';
import 'package:asrdb/core/models/auth/auth_esri_response.dart';
import 'package:asrdb/core/models/auth/auth_response.dart';
import 'package:asrdb/core/models/auth/auth_response2.dart';
import 'package:asrdb/core/models/auth/refresh_token_request.dart';
import 'package:asrdb/core/services/storage_service.dart';
import 'package:asrdb/core/services/json_file_service.dart';

class AuthService {
  final AuthApi authApi;
  AuthService(this.authApi);
  final StorageService _storage = StorageService();
  final JsonFileService _jsonFileService = JsonFileService();

  Future<AuthResponse> verifyOtp(String userId, String otp) async {
    try {
      final response = await authApi.verifyOtp(userId, otp);

      // Here you would parse the response and handle tokens, errors, etc.
      if (response.statusCode == 200) {
        AuthResponse authResponse = AuthResponse.fromJson(response.data);
        await _storage.saveString(
            key: StorageKeys.accessToken, value: authResponse.accessToken);
        await _storage.saveString(
            key: StorageKeys.refreshToken, value: authResponse.refreshToken);
        await _storage.saveString(
            key: StorageKeys.idhToken, value: authResponse.idToken);

        await loginEsri();
        await _saveJsonFilesIfNeeded();

        return authResponse;
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<AuthResponse2> login(String email, String password) async {
    try {
      final response = await authApi.login(email, password);

      // Here you would parse the response and handle tokens, errors, etc.
      if (response.statusCode == 200) {
        AuthResponse2 authResponse = AuthResponse2.fromJson(response.data);
        // await _storage.saveString(
        //     key: StorageKeys.accessToken, value: authResponse.accessToken);
        // await _storage.saveString(
        //     key: StorageKeys.refreshToken, value: authResponse.refreshToken);
        // await _storage.saveString(
        //     key: StorageKeys.idhToken, value: authResponse.idToken);

        // await loginEsri();
        // await _saveJsonFilesIfNeeded();

        return authResponse;
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<AuthEsriResponse> loginEsri() async {
    String? accessToken =
        await _storage.getString(key: StorageKeys.accessToken);
    try {
      if (accessToken == null) throw Exception('Failed to login to esri!!');

      final response = await authApi.loginEsri(accessToken);

      // Here you would parse the response and handle tokens, errors, etc.
      if (response.statusCode == 200) {
        AuthEsriResponse authResponse =
            AuthEsriResponse.fromJson(response.data);
        await _storage.saveString(
            key: StorageKeys.esriAccessToken, value: authResponse.accessToken);

        return authResponse;
      } else {
        throw Exception('Failed to login to esri!!!');
      }
    } catch (e) {
      throw Exception('Failed to login to esri!!!!: $e');
    }
  }

  Future<AuthResponse> refreshToken() async {
    try {
      String? refreshToken =
          await _storage.getString(key: StorageKeys.refreshToken);
      String? accessToken =
          await _storage.getString(key: StorageKeys.accessToken);
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
            key: StorageKeys.accessToken, value: authResponse.accessToken);
        await _storage.saveString(
            key: StorageKeys.refreshToken, value: authResponse.refreshToken);
        await _storage.saveString(
            key: StorageKeys.idhToken, value: authResponse.idToken);

        final esriResponse = await authApi.loginEsri(accessToken);
        if (esriResponse.statusCode == 200) {
          AuthEsriResponse authResponse =
              AuthEsriResponse.fromJson(response.data);
          await _storage.saveString(
              key: StorageKeys.esriAccessToken,
              value: authResponse.accessToken);
        }
        return authResponse;
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<void> _saveJsonFilesIfNeeded() async {
    try {
      final filesExist = await _jsonFileService.areJsonFilesExist();

      if (!filesExist) {
        await _jsonFileService.saveJsonFiles();
      }
    } catch (e) {
      // Don't throw here as login should still succeed even if JSON saving fails
    }
  }

  Future<void> saveJsonFiles() async {
    try {
      await _jsonFileService.saveJsonFiles();
    } catch (e) {
      throw Exception('Failed to save JSON files: $e');
    }
  }

  Future<void> logout() async {
    try {
      // Clear all stored tokens
      await _storage.remove(key: StorageKeys.accessToken);
      await _storage.remove(key: StorageKeys.refreshToken);
      await _storage.remove(key: StorageKeys.idhToken);
      await _storage.remove(key: StorageKeys.esriAccessToken);
      await _storage.remove(key: StorageKeys.userProfile);
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }
}
