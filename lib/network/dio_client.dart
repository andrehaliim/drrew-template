import 'package:dio/dio.dart';
import 'package:drrew_template/config/env/env.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

Dio createDioClient({required Future<String?> Function() getToken}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.apiBaseUrl,
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