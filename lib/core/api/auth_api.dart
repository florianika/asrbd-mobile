import 'package:dio/dio.dart';
import 'api_client.dart';
import 'api_endpoints.dart';
import 'package:asrdb/core/config/app_config.dart';

class AuthApi {
  final ApiClient _apiClient = ApiClient(AppConfig.apiBaseUrl);

  Future<Response> login(String email, String password) async {
    return await _apiClient.post(
      ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );
  }
}
