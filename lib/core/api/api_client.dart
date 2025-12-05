import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:asrdb/core/api/auth_api.dart';
import 'package:asrdb/core/services/auth_service.dart';
import 'package:asrdb/core/services/storage_service.dart';
import 'package:asrdb/core/config/app_config.dart';
import 'package:asrdb/routing/route_manager.dart';
import 'package:asrdb/main.dart';
import 'api_exceptions.dart';

class ApiClient {
  static ApiClient? _instance;
  late Dio dio;

  factory ApiClient({String? baseUrl, Map<String, String>? headers}) {
    _instance ??= ApiClient._internal(
      baseUrl ?? AppConfig.apiBaseUrl,
      headers: headers,
    );
    return _instance!;
  }

  ApiClient._internal(String baseUrl, {Map<String, String>? headers}) {
    final mergedHeaders = {
      if (headers != null) ...headers,
      if (headers == null || !headers.containsKey('Content-Type'))
        'Content-Type': 'application/json',
    };

    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: AppConfig.apiTimeout),
        receiveTimeout: const Duration(seconds: AppConfig.apiTimeout),
        headers: mergedHeaders,
      ),
    );

    // Add refresh token interceptor
    dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException error, ErrorInterceptorHandler handler) async {
        // Don't retry if it's already a refresh token request to prevent infinite loops
        final isRefreshTokenRequest =
            error.requestOptions.path.contains('refresh');

        if (error.response?.statusCode == 401 && !isRefreshTokenRequest) {
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
            // Refresh token failed (likely expired) - redirect to login
            _handleUnauthorized();
            return handler.next(error);
          }
        }

        return handler.next(error);
      },
    ));

    dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  /// Manually update or add new headers (e.g., after login)
  void setHeaders(Map<String, String> newHeaders) {
    dio.options.headers.addAll(newHeaders);
  }

  /// Optional: Remove a header
  void removeHeader(String key) {
    dio.options.headers.remove(key);
  }

  /// Optional: Reset entire header set
  void clearHeaders() {
    dio.options.headers.clear();
  }

  /// Handle unauthorized access - clear tokens and redirect to login
  void _handleUnauthorized() {
    try {
      // Clear stored tokens asynchronously
      _clearStoredTokens();

      // Navigate to login screen
      final context = rootNavigatorKey.currentContext;
      if (context != null && context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteManager.loginRoute,
          (route) => false,
        );
      }
    } catch (e) {
      debugPrint('Error handling unauthorized access: $e');
    }
  }

  /// Clear all stored tokens
  void _clearStoredTokens() {
    try {
      final storage = StorageService();
      // Fire and forget - clear tokens in background
      storage.remove(key: 'accessToken');
      storage.remove(key: 'refreshToken');
      storage.remove(key: 'idhToken');
      storage.remove(key: 'esriAccessToken');
    } catch (e) {
      debugPrint('Error clearing tokens: $e');
    }
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
