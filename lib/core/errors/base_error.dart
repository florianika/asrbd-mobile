abstract class BaseError implements Exception {
  final String message;
  BaseError(this.message);

  @override
  String toString() {
    return message;
  }
}
