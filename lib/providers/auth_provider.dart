import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:drrew_template/network/api_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/auth_state.dart';
import 'dio_provider.dart';
import 'secure_storage_provider.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {

  @override
  Future<AuthState> build() async {
    final storage = ref.watch(secureStorageProvider);
    final token = await storage.read(key: tokenStorageKey);

    if (token == null) {
      return const AuthState(status: AuthStatus.unauthenticated);
    }

    try {
      final dio = ref.read(dioProvider);
      final response = await dio.get('/auth/me');
      final data = response.data as Map<String, dynamic>;

      return AuthState(
        status: AuthStatus.authenticated,
        userId: data['id'] as int?,
        email: data['email'] as String?,
        fullName: data['full_name'] as String?,
      );
    } on DioException {
      await storage.delete(key: tokenStorageKey);
      await storage.delete(key: refreshTokenStorageKey);
      return const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncData(AuthState(status: AuthStatus.loading));

    final dio = ref.read(dioProvider);
    final storage = ref.read(secureStorageProvider);

    try {
      final response = await dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = response.data as Map<String, dynamic>;
      final accessToken = data['access_token'] as String;
      final refreshToken = data['refresh_token'] as String;

      await storage.write(key: tokenStorageKey, value: accessToken);
      await storage.write(key: refreshTokenStorageKey, value: refreshToken);
      
      log("accessToken: $accessToken");
      log("refreshToken: $refreshToken");

      final meResponse = await dio.get('/auth/me');
      final me = meResponse.data as Map<String, dynamic>;

      state = AsyncData(
        AuthState(
          status: AuthStatus.authenticated,
          userId: me['id'] as int?,
          email: me['email'] as String?,
          fullName: me['full_name'] as String?,
        ),
      );
    } on DioException catch (e) {
      final message = e.error is ApiException
          ? (e.error as ApiException).message
          : 'Login gagal, coba lagi.';

      state = AsyncData(
        AuthState(status: AuthStatus.error, errorMessage: message),
      );
    }
  }

  Future<void> register({
    required String email,
    required String password,
    String? fullName,
  }) async {
    final dio = ref.read(dioProvider);

    try {
      await dio.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          'full_name': fullName ?? 'User',
        },
      );
      await login(email, password);
    } on DioException catch (e) {
      final message = e.error is ApiException
          ? (e.error as ApiException).message
          : 'Registrasi gagal, coba lagi.';

      state = AsyncData(
        AuthState(status: AuthStatus.error, errorMessage: message),
      );
    }
  }

  Future<void> logout({bool notifyBackend = true}) async {
  final storage = ref.read(secureStorageProvider);

  if (notifyBackend) {
    final dio = ref.read(dioProvider);
    final refreshToken = await storage.read(key: refreshTokenStorageKey);

    if (refreshToken != null) {
      try {
        await dio.post('/auth/logout', data: {'refresh_token': refreshToken});
      } on DioException {
        // best-effort, tetap lanjut hapus token lokal
      }
    }
  }

  await storage.delete(key: tokenStorageKey);
  await storage.delete(key: refreshTokenStorageKey);
  state = const AsyncData(AuthState(status: AuthStatus.unauthenticated));
}

  
  Future<void> refreshUser() async {
    final current = state.value;
    if (current == null || current.status != AuthStatus.authenticated) return;

    final dio = ref.read(dioProvider);
    try {
      final response = await dio.get('/auth/me');
      final data = response.data as Map<String, dynamic>;

      state = AsyncData(
        AuthState(
          status: AuthStatus.authenticated,
          userId: data['id'] as int?,
          email: data['email'] as String?,
          fullName: data['full_name'] as String?,
        ),
      );
    } on DioException {
      // Kalau access token expired, AuthInterceptor yang sudah ada
      // seharusnya sudah coba silent-refresh + retry. Kalau tetap gagal,
      // biarkan saja — jangan langsung logout dari sini supaya tidak
      // mengganggu UX di tengah navigasi tab.
    }
  }
}

//accessToken: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJnYW50ZW5nQGdtYWlsLmNvbSIsImV4cCI6MTc4ODQ4OTE3MSwidHlwZSI6ImFjY2VzcyJ9.PdrhnG9o0nbY0ymuawTy_iwwsxZiNl5ZzVE5vnoDT1M
//refreshToken: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJnYW50ZW5nQGdtYWlsLmNvbSIsImV4cCI6MTc4OTA5MzkxMSwidHlwZSI6InJlZnJlc2giLCJqdGkiOiI0MzAwMGJkNi00YmExLTQ5MjQtOGJiZS0xNjJhMTYyZmRlYjMifQ.jc8pLT9au4QOUNup1St00Aly4JKxsMZSpWVS5AnkABQ