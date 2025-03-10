import 'dart:io';
import 'package:dio/dio.dart';

class ApiExceptions implements Exception {
  final String message;
  ApiExceptions(this.message);

  static String handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return 'Connection Timeout';
        case DioExceptionType.receiveTimeout:
          return 'Receive Timeout';
        case DioExceptionType.badResponse:
          return 'Server Error: ${error.response?.statusCode}';
        case DioExceptionType.cancel:
          return 'Request Cancelled';
        case DioExceptionType.unknown:
        default:
          return 'Unexpected Error';
      }
    } else if (error is SocketException) {
      return 'No Internet Connection';
    }
    return 'Unexpected Error';
  }
}
