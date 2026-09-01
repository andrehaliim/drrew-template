import 'package:drrew_template/models/auth_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  AuthState build() {
    return const AuthState(status: AuthStatus.unauthenticated);
  }

  Future<void> login(String email, String password) async {
    state = const AuthState(status: AuthStatus.loading);
    await Future.delayed(const Duration(seconds: 3));

    if (email == 'admin@mail.com' && password == 'welcome123') {
      state = const AuthState(status: AuthStatus.authenticated);
    } else {
      state = const AuthState(
        status: AuthStatus.error,
        errorMessage: 'Email atau password salah.',
      );
    }
  }

  void logout() {
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}