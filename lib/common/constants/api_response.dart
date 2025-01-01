class ApiSuccess<T> {
  final int statusCode;
  final T? data;

  ApiSuccess({
    required this.statusCode,
    required this.data,
  });

  @override
  String toString() {
    return 'ApiSuccess{statusCode: $statusCode, data: $data}';
  }
}

class ApiError {
  final int statusCode;
  final String message;

  ApiError({
    required this.statusCode,
    required this.message,
  });

  @override
  String toString() {
    return 'ApiError{statusCode: $statusCode, message: $message}';
  }
}
