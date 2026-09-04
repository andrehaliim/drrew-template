// lib/network/interceptors/token_refresh_interceptor.dart
import 'dart:async';
import 'package:dio/dio.dart';

typedef TokenPair = ({String accessToken, String refreshToken});

class TokenRefreshInterceptor extends Interceptor {
  TokenRefreshInterceptor({
    required this.dio,
    required this.getRefreshToken,
    required this.onTokenRefreshed,
    required this.onRefreshFailed,
  });

  final Dio dio;
  final Future<String?> Function() getRefreshToken;
  final Future<void> Function(TokenPair tokens) onTokenRefreshed;
  final Future<void> Function() onRefreshFailed;

  bool _isRefreshing = false;
  final List<Completer<void>> _waiters = [];

  // Endpoint-endpoint ini 401-nya bukan berarti access token expired,
  // jadi jangan pernah dianggap sebagai trigger auto-refresh.
  static const _excludedPaths = [
    '/auth/login',
    '/auth/register',
    '/auth/refresh',
    '/auth/logout',
  ];

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final isUnauthorized = err.response?.statusCode == 401;
    final isExcluded = _excludedPaths.any(
      (path) => err.requestOptions.path.contains(path),
    );

    if (!isUnauthorized || isExcluded) {
      return handler.next(err);
    }

    try {
      await _refreshToken();
      final response = await dio.fetch(err.requestOptions);
      return handler.resolve(response);
    } catch (_) {
      await onRefreshFailed();
      return handler.next(err);
    }
  }

  Future<void> _refreshToken() async {
    if (_isRefreshing) {
      final completer = Completer<void>();
      _waiters.add(completer);
      return completer.future;
    }

    _isRefreshing = true;
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) throw Exception('No refresh token stored');

      final response = await dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      final data = response.data as Map<String, dynamic>;

      await onTokenRefreshed((
        accessToken: data['access_token'] as String,
        refreshToken: data['refresh_token'] as String,
      ));

      for (final waiter in _waiters) {
        waiter.complete();
      }
    } catch (e) {
      for (final waiter in _waiters) {
        waiter.completeError(e);
      }
      rethrow;
    } finally {
      _isRefreshing = false;
      _waiters.clear();
    }
  }
}