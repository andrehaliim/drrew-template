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

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final isUnauthorized = err.response?.statusCode == 401;
    final isRefreshCall = err.requestOptions.path.contains('/auth/refresh');

    // bukan 401, atau ini justru error dari endpoint refresh itu sendiri
    // (biar gak infinite loop) -> teruskan error apa adanya
    if (!isUnauthorized || isRefreshCall) {
      return handler.next(err);
    }

    try {
      await _refreshToken();
      // token baru sudah tersimpan, AuthInterceptor akan otomatis
      // pasang token baru saat request ini di-retry
      final response = await dio.fetch(err.requestOptions);
      return handler.resolve(response);
    } catch (_) {
      // refresh token juga gagal/expired -> paksa logout
      await onRefreshFailed();
      return handler.next(err);
    }
  }

  Future<void> _refreshToken() async {
    // kalau ada request lain yang lagi nunggu refresh selesai,
    // ikut antre daripada nembak /auth/refresh berkali-kali bersamaan
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