import 'package:dio/dio.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

Dio createDioClient({required String? Function() getToken}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.example.com', // TODO: ganti sesuai project, idealnya dari env config
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  dio.interceptors.addAll([
    AuthInterceptor(getToken: getToken),
    LoggingInterceptor(),
    ErrorInterceptor(),
  ]);

  return dio;
}