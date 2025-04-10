import 'dart:async';
import 'package:dio/dio.dart';
import 'api_exceptions.dart';
import 'package:asrdb/core/config/app_config.dart';

class ApiClient {
  static ApiClient? _instance;

  late Dio dio;

  factory ApiClient(String baseUrl) {
    _instance ??= ApiClient._internal(baseUrl);
    return _instance!;
  }

  ApiClient._internal(String baseUrl)
      : dio = Dio(
          BaseOptions(
            baseUrl: AppConfig.apiBaseUrl,
            connectTimeout: const Duration(seconds: AppConfig.apiTimeout),
            receiveTimeout: const Duration(seconds: AppConfig.apiTimeout),
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        ) {
    dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  // GET Request
  Future<Response> get(String endpoint, {Map<String, dynamic>? params}) async {
    try {
      return await dio.get(endpoint, queryParameters: params);
    } catch (e) {
      throw ApiExceptions.handleError(e);
    }
  }

  // POST Request
  Future<Response> post(String endpoint, {dynamic data}) async {
    try {
      return await dio.post(endpoint, data: data);
    } catch (e) {
      throw ApiExceptions.handleError(e);
    }
  }
}
