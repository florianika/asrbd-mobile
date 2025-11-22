import 'package:asrdb/core/api/auth_api.dart';
import 'package:asrdb/core/local_storage/storage_keys.dart';
import 'package:asrdb/core/models/auth/auth_esri_response.dart';
import 'package:asrdb/core/models/auth/auth_response.dart';
import 'package:asrdb/core/models/auth/auth_response2.dart';
import 'package:asrdb/core/models/auth/refresh_token_request.dart';
import 'package:asrdb/core/services/storage_service.dart';
import 'package:asrdb/core/services/json_file_service.dart';
import 'package:asrdb/core/services/secure_storage_service.dart';
import 'dart:async';

class AuthService {
  final AuthApi authApi;
  final SecureStorageService _secureStorage;
  final StorageService _storage = StorageService();
  final JsonFileService _jsonFileService = JsonFileService();
  Timer? _refreshTimer;

  AuthService(this.authApi, {SecureStorageService? secureStorage})
      : _secureStorage = secureStorage ?? SecureStorageService();

  Future<AuthResponse> verifyOtp(String userId, String otp) async {
    try {
      final response = await authApi.verifyOtp(userId, otp);

      // Here you would parse the response and handle tokens, errors, etc.
      if (response.statusCode == 200) {
        AuthResponse authResponse = AuthResponse.fromJson(response.data);
        await _secureStorage.write(
            key: StorageKeys.accessToken, value: authResponse.accessToken);
        await _secureStorage.write(
            key: StorageKeys.refreshToken, value: authResponse.refreshToken);
        await _secureStorage.write(
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
        await _secureStorage.read(key: StorageKeys.accessToken);
    try {
      if (accessToken == null) throw Exception('Failed to login to esri!!');

      final response = await authApi.loginEsri(accessToken);

      // Here you would parse the response and handle tokens, errors, etc.
      if (response.statusCode == 200) {
        AuthEsriResponse authResponse =
            AuthEsriResponse.fromJson(response.data);
        await _secureStorage.write(
            key: StorageKeys.esriAccessToken, value: authResponse.accessToken);

        // Schedule refresh if expires is available
        if (authResponse.expires != null) {
           _scheduleTokenRefresh(authResponse.expires!);
        }

        return authResponse;
      } else {
        throw Exception('Failed to login to esri!!!');
      }
    } catch (e) {
      throw Exception('Failed to login to esri!!!!: $e');
    }
  }

  void _scheduleTokenRefresh(int expires) {
    _refreshTimer?.cancel();
    // Assuming expires is a timestamp in milliseconds or seconds. 
    // If it's duration in minutes/seconds, logic changes.
    // Common ArcGIS pattern: expires is epoch in milliseconds.
    // User said: "Token is valid for a configurable duration (e.g., 30 minutes, 1 hour)."
    // And "Track expires timestamp from token response."
    
    // Let's assume expires is a timestamp (epoch ms) for now, as is standard for Esri.
    // If it's a duration, we would add it to current time.
    // Safest bet: Check if it's a large number (timestamp) or small (duration).
    // Or just assume timestamp as per "expires timestamp" wording.
    
    final now = DateTime.now().millisecondsSinceEpoch;
    final expiresMs = expires; // Assuming input is ms
    
    // Refresh 5 minutes before expiry
    final refreshTime = expiresMs - (5 * 60 * 1000);
    final duration = refreshTime - now;

    if (duration > 0) {
      _refreshTimer = Timer(Duration(milliseconds: duration), () {
        refreshToken();
      });
    }
  }

  Future<AuthResponse> refreshToken() async {
    try {
      String? refreshToken =
          await _secureStorage.read(key: StorageKeys.refreshToken);
      String? accessToken =
          await _secureStorage.read(key: StorageKeys.accessToken);
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
        await _secureStorage.write(
            key: StorageKeys.accessToken, value: authResponse.accessToken);
        await _secureStorage.write(
            key: StorageKeys.refreshToken, value: authResponse.refreshToken);
        await _secureStorage.write(
            key: StorageKeys.idhToken, value: authResponse.idToken);

        final esriResponse = await authApi.loginEsri(authResponse.accessToken);
        if (esriResponse.statusCode == 200) {
          AuthEsriResponse authEsriResponse =
              AuthEsriResponse.fromJson(esriResponse.data);
          await _secureStorage.write(
              key: StorageKeys.esriAccessToken,
              value: authEsriResponse.accessToken);
           
           if (authEsriResponse.expires != null) {
             _scheduleTokenRefresh(authEsriResponse.expires!);
           }
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
      await _secureStorage.deleteAll();
      _refreshTimer?.cancel();
      // await _storage.remove(key: StorageKeys.accessToken);
      // await _storage.remove(key: StorageKeys.refreshToken);
      // await _storage.remove(key: StorageKeys.idhToken);
      // await _storage.remove(key: StorageKeys.esriAccessToken);
      await _storage.remove(key: StorageKeys.userProfile);
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }
}
