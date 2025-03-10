class BaseResponse<T> {
  final bool success;
  final String message;
  final T? data;

  BaseResponse({required this.success, required this.message, this.data});

  factory BaseResponse.fromJson(Map<String, dynamic> json, Function fromJsonT) {
    return BaseResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson(Function toJsonT) {
    return {
      'success': success,
      'message': message,
      'data': data != null ? toJsonT(data) : null,
    };
  }
}
