// lib/providers/dio_provider.dart
import 'package:dio/dio.dart';
import 'package:drrew_template/widgets/app_messenger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../network/dio_client.dart';
import '../network/interceptors/token_refresh_interceptor.dart';
import 'auth_provider.dart';
import 'secure_storage_provider.dart';

part 'dio_provider.g.dart';

const tokenStorageKey = 'auth_token';
const refreshTokenStorageKey = 'refresh_token';

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final storage = ref.watch(secureStorageProvider);

  final dio = createDioClient(
    getToken: () => storage.read(key: tokenStorageKey),
  );

  dio.interceptors.insert(
    0,
    TokenRefreshInterceptor(
      dio: dio,
      getRefreshToken: () => storage.read(key: refreshTokenStorageKey),
      onTokenRefreshed: (tokens) async {
        await storage.write(key: tokenStorageKey, value: tokens.accessToken);
        await storage.write(
          key: refreshTokenStorageKey,
          value: tokens.refreshToken,
        );
      },
      onRefreshFailed: () async {
        await ref
            .read(authControllerProvider.notifier)
            .logout(
              notifyBackend: false,
            ); 
        await Future.delayed(const Duration(milliseconds: 300));
        showFloatingSnackBar('Session expired, please login again.');
      },
    ),
  );

  return dio;
}
