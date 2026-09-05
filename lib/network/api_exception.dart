enum ApiExceptionType { network, timeout, unauthorized, forbidden, notFound, server, unknown }

class ApiException implements Exception {
  ApiException({
    required this.message,
    required this.type,
    this.statusCode,
  });

  final String message;
  final ApiExceptionType type;
  final int? statusCode;

  bool get isNetworkError => type == ApiExceptionType.network;

  @override
  String toString() => message;
}