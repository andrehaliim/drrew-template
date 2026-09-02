enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  const AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.userId,
    this.email,
    this.fullName,
  });

  final AuthStatus status;
  final String? errorMessage;
  final int? userId;
  final String? email;
  final String? fullName;

  bool get isLoading => status == AuthStatus.loading;
  bool get isAuthenticated => status == AuthStatus.authenticated;
}