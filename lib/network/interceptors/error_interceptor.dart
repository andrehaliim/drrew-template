import 'package:dio/dio.dart';
import '../api_exception.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final message = switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        'Connection Timeout, try again',
      DioExceptionType.connectionError =>
        'No internet connection',
      DioExceptionType.badResponse =>
        _messageFromResponse(err.response),
      _ => 'Something went wrong, try again',
    };

    final apiException = ApiException(
      message: message,
      statusCode: err.response?.statusCode,
    );

    handler.next(err.copyWith(error: apiException));
  }

  String _messageFromResponse(Response? response) {
    if (response?.data is Map && response?.data['message'] != null) {
      return response!.data['message'] as String;
    }
    return switch (response?.statusCode) {
      401 => 'Session ended, please login again.',
      403 => 'You do not have access.',
      404 => 'Data not found.',
      500 => 'Server is having problems.',
      _ => 'Something went wrong, try again.',
    };
  }
}