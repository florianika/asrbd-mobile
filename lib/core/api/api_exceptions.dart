import 'dart:io';
import 'package:dio/dio.dart';

class ApiExceptions implements Exception {
  static Exception handleError(dynamic error) {
    if (error is DioException) {
      final response = error.response;
      final statusCode = response?.statusCode ?? 0;
      final message = _extractMessage(response);

      return Exception('API Error $statusCode: ${message ?? error.message}');
    } else {
      return Exception('Unexpected error: $error');
    }
  }

  static String? _extractMessage(Response? response) {
    if (response == null) return null;

    final data = response.data;

    if (data == null) return null;

    // Handle common types: Map, String, etc.
    if (data is String) {
      return data;
    } else if (data is Map<String, dynamic>) {
      // Customize this based on your API's error format
      if (data.containsKey('message')) return data['message'];
      if (data.containsKey('error')) return data['error'];
      return data.toString();
    } else {
      return data.toString();
    }
  }
}
