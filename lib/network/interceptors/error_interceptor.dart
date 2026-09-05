// lib/network/interceptors/error_interceptor.dart
import 'package:dio/dio.dart';
import '../api_exception.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final type = _typeFromDioException(err);
    final message = switch (type) {
      ApiExceptionType.timeout => 'Connection Timeout, try again',
      ApiExceptionType.network => 'No internet connection',
      ApiExceptionType.unauthorized => 'Session ended, please login again.',
      ApiExceptionType.forbidden => 'You do not have access.',
      ApiExceptionType.notFound => 'Data not found.',
      ApiExceptionType.server => 'Server is having problems.',
      ApiExceptionType.unknown => _messageFromResponse(err.response),
    };

    final apiException = ApiException(
      message: message,
      type: type,
      statusCode: err.response?.statusCode,
    );

    handler.next(err.copyWith(error: apiException));
  }

  ApiExceptionType _typeFromDioException(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiExceptionType.timeout;
      case DioExceptionType.connectionError:
        return ApiExceptionType.network;
      case DioExceptionType.badResponse:
        return switch (err.response?.statusCode) {
          401 => ApiExceptionType.unauthorized,
          403 => ApiExceptionType.forbidden,
          404 => ApiExceptionType.notFound,
          500 => ApiExceptionType.server,
          _ => ApiExceptionType.unknown,
        };
      default:
        return ApiExceptionType.unknown;
    }
  }

  String _messageFromResponse(Response? response) {
    if (response?.data is Map && response?.data['detail'] != null) {
      return response!.data['detail'] as String;
    }
    return 'Something went wrong, try again.';
  }
}