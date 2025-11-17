import 'package:asrdb/core/models/auth/refresh_token_request.dart';
import 'package:dio/dio.dart';
import 'api_client.dart';
import 'api_endpoints.dart';
import 'package:asrdb/core/config/app_config.dart';

class AuthApi {
  final ApiClient _apiClient = ApiClient(baseUrl: AppConfig.apiBaseUrl);
  Future<Response> login(String email, String password) async {
    return await _apiClient.post(
      ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );
  }

  Future<Response> verifyOtp(String userId, String c) async {
    return await _apiClient.post(
      ApiEndpoints.verifyOtp,
      data: {
        'userId': userId,
        'code': userId,
      },
    );
  }

  Future<Response> refreshToken(RefreshTokenRequest refreshTokenRequest) async {
    return await _apiClient.post(
      ApiEndpoints.refreshToken,
      data: refreshTokenRequest.toJson(),
    );
  }

  Future<Response> loginEsri(String authToken) async {
    Map<String, String> authHeader = <String, String>{
      "Authorization": 'Bearer $authToken'
    };

    _apiClient.setHeaders(authHeader);
    return await _apiClient.get(ApiEndpoints.loginEsri);
  }
}
