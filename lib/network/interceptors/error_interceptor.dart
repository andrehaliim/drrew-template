import 'package:dio/dio.dart';
import '../api_exception.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final message = switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        'Koneksi timeout, coba lagi.',
      DioExceptionType.connectionError =>
        'Tidak ada koneksi internet.',
      DioExceptionType.badResponse =>
        _messageFromResponse(err.response),
      _ => 'Terjadi kesalahan, coba lagi.',
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
      401 => 'Sesi berakhir, silakan login kembali.',
      403 => 'Anda tidak memiliki akses.',
      404 => 'Data tidak ditemukan.',
      500 => 'Server sedang bermasalah.',
      _ => 'Terjadi kesalahan, coba lagi.',
    };
  }
}