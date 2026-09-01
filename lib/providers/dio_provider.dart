import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../network/dio_client.dart';
import 'secure_storage_provider.dart';

part 'dio_provider.g.dart';

const tokenStorageKey = 'auth_token';

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final storage = ref.watch(secureStorageProvider);
  return createDioClient(
    getToken: () => storage.read(key: tokenStorageKey),
  );
}