import 'dart:async';
import 'package:dio/dio.dart';
import 'package:asrdb/core/api/auth_api.dart';
import 'package:asrdb/core/services/auth_service.dart';
import 'package:asrdb/core/config/app_config.dart';
import 'api_exceptions.dart';

class EsriApiClient {
  static EsriApiClient? _instance;
  late Dio dio;

  factory EsriApiClient() {
    _instance ??= EsriApiClient._internal();
    return _instance!;
  }

  EsriApiClient._internal() {
  
    dio = Dio(
      BaseOptions(    
        connectTimeout: const Duration(seconds: AppConfig.apiTimeout),
        receiveTimeout: const Duration(seconds: AppConfig.apiTimeout),
      ),
    );

    // Add refresh token interceptor
    dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException error, ErrorInterceptorHandler handler) async {
        if (error.response?.statusCode == 401) {
          try {
            AuthApi authApi = AuthApi();
            AuthService authService = AuthService(authApi);

            final refreshed = await authService.refreshToken();
            final options = error.requestOptions;

            // Clone request with updated token
            options.headers['Authorization'] =
                'Bearer ${refreshed.accessToken}';

            final retryResponse = await dio.fetch(options);
            return handler.resolve(retryResponse);
          } catch (e) {
            return handler.next(error);
          }
        }

        return handler.next(error);
      },
    ));

    dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  /// GET request
  Future<Response> get(String endpoint, {Map<String, dynamic>? params}) async {
    try {
      return await dio.get(endpoint, queryParameters: params);
    } catch (e) {
      throw ApiExceptions.handleError(e);
    }
  }

  /// POST request
  Future<Response> post(String endpoint, {dynamic data}) async {
    try {
      return await dio.post(endpoint, data: data);
    } catch (e) {
      throw ApiExceptions.handleError(e);
    }
  }
}
