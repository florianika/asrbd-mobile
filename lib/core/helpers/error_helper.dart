// core/helpers/error_helper.dart

class ErrorHelper {
  static String getErrorMessage(dynamic error) {
    if (error is Exception) {
      return error.toString();
    } else if (error is String) {
      return error;
    }
    return "An unknown error occurred";
  }
}
