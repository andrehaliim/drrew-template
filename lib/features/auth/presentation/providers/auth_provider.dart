import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/auth_status.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  AuthStatus build() {
    return AuthStatus.unauthenticated;
  }

  void login() {
    state = AuthStatus.authenticated;
  }

  void logout() {
    state = AuthStatus.unauthenticated;
  }
}