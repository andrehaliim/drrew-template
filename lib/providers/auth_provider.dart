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

    return AuthState(
      status: token != null
          ? AuthStatus.authenticated
          : AuthStatus.unauthenticated,
    );
  }

  Future<void> login(String email, String password) async {
    state = const AsyncData(AuthState(status: AuthStatus.loading));
    await Future.delayed(const Duration(seconds: 3));
    if (email == 'admin@mail.com' && password == 'welcome123') {
      final storage = ref.read(secureStorageProvider);
      await storage.write(key: tokenStorageKey, value: 'dummy_token_12345');
      state = const AsyncData(AuthState(status: AuthStatus.authenticated));
    } else {
      state = const AsyncData(
        AuthState(
          status: AuthStatus.error,
          errorMessage: 'Wrong email or password',
        ),
      );
    }

    // TODO: Uncomment for real API integration
    /*final dio = ref.read(dioProvider);
    final storage = ref.read(secureStorageProvider);

    try {
      final response = await dio.post(
        '/user/login',
        data: {
          'username': username,
          'password': password,
        },
      );

      final data = response.data['data'] as Map<String, dynamic>;
      final token = data['token'] as String;

      await storage.write(key: tokenStorageKey, value: token);

      state = AsyncData(
        AuthState(
          status: AuthStatus.authenticated,
          userId: data['ID'] as int?,
          nickname: data['nickname'] as String?,
          branchNo: data['BranchNo'] as String?,
        ),
      );
    } on DioException catch (e) {
      final message = e.error is ApiException
          ? (e.error as ApiException).message
          : 'Login failed, try again.';

      state = AsyncData(
        AuthState(status: AuthStatus.error, errorMessage: message),
      );
    }*/
  }

  Future<void> logout() async {
    final storage = ref.read(secureStorageProvider);
    await storage.delete(key: tokenStorageKey);
    state = const AsyncData(AuthState(status: AuthStatus.unauthenticated));
  }
}