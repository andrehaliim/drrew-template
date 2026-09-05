// lib/widgets/app_state_view.dart
import 'package:drrew_template/network/api_exception.dart';
import 'package:drrew_template/widgets/app_buttons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppStateType { empty, error, noInternet }

class AppStateView extends StatelessWidget {
  const AppStateView({
    super.key,
    required this.type,
    this.title,
    this.subtitle,
    this.onRetry,
    this.retryLabel = 'Try Again',
  });

  final AppStateType type;
  final String? title;
  final String? subtitle;
  final VoidCallback? onRetry;
  final String retryLabel;

  /// Factory: bikin AppStateView langsung dari ApiException,
  /// otomatis pilih noInternet kalau error-nya connection error.
  factory AppStateView.fromException(
    ApiException exception, {
    VoidCallback? onRetry,
  }) {
    return AppStateView(
      type: exception.isNetworkError ? AppStateType.noInternet : AppStateType.error,
      subtitle: exception.message,
      onRetry: onRetry,
    );
  }

  IconData get _icon => switch (type) {
        AppStateType.empty => Icons.inbox_outlined,
        AppStateType.error => Icons.error_outline_rounded,
        AppStateType.noInternet => Icons.wifi_off_rounded,
      };

  String get _defaultTitle => switch (type) {
        AppStateType.empty => 'Nothing here yet',
        AppStateType.error => 'Something went wrong',
        AppStateType.noInternet => 'No internet connection',
      };

  String get _defaultSubtitle => switch (type) {
        AppStateType.empty => 'There\'s no data to show right now.',
        AppStateType.error => 'Please try again in a moment.',
        AppStateType.noInternet => 'Check your connection and try again.',
      };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_icon, size: 56, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
            const SizedBox(height: 16),
            Text(
              title ?? _defaultTitle,
              style: GoogleFonts.inter(
                fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle ?? _defaultSubtitle,
              style: GoogleFonts.inter(
                fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: 160,
                child: AppButtons.outlinedButton(
                  context: context,
                  label: retryLabel,
                  onPressed: onRetry,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}