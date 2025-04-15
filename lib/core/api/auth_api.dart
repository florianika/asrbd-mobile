import 'package:asrdb/core/models/auth/refresh_token_request.dart';
import 'package:dio/dio.dart';
import 'api_client.dart';
import 'api_endpoints.dart';
import 'package:asrdb/core/config/app_config.dart';

class AuthApi {
  Future<Response> login(String email, String password) async {
    final ApiClient apiClient = ApiClient(AppConfig.apiBaseUrl);
    return await apiClient.post(
      ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );
  }

  Future<Response> refreshToken(RefreshTokenRequest refreshTokenRequest) async {
    final ApiClient apiClient = ApiClient(AppConfig.apiBaseUrl);
    return await apiClient.post(
      ApiEndpoints.refreshToken,
      data: refreshTokenRequest.toJson(),
    );
  }

  Future<Response> loginEsri(String authToken) async {
    Map<String, String> authHeader = <String, String>{
      "Authorization": 'Bearer $authToken'
    };

    final ApiClient apiClient = ApiClient(
      AppConfig.apiBaseUrl,
      header: authHeader,
    );

    return await apiClient.get(ApiEndpoints.loginEsri);
  }
}
