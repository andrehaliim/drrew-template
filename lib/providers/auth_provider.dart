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
      status: token != null ? AuthStatus.authenticated : AuthStatus.unauthenticated,
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
          errorMessage: 'Email atau password salah.',
        ),
      );
    }
  }

  Future<void> logout() async {
    final storage = ref.read(secureStorageProvider);
    await storage.delete(key: tokenStorageKey);
    state = const AsyncData(AuthState(status: AuthStatus.unauthenticated));
  }
}