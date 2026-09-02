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

  Future<void> logout() async {
    final storage = ref.read(secureStorageProvider);
    await storage.delete(key: tokenStorageKey);
    await storage.delete(key: refreshTokenStorageKey);
    state = const AsyncData(AuthState(status: AuthStatus.unauthenticated));
  }
}