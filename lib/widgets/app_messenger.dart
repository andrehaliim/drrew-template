import 'package:flutter/material.dart';

/// Global key supaya snackbar bisa ditampilkan dari luar widget tree,
/// misalnya dari interceptor Dio saat refresh token gagal.
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void showFloatingSnackBar(String message) {
  scaffoldMessengerKey.currentState
    ?..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
}