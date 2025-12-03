class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  AppException(this.message, {this.statusCode, this.details});

  @override
  String toString() =>
      'AppException(message: $message, statusCode: $statusCode, details: $details)';
}
