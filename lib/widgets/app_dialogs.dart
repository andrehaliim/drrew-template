import 'package:drrew_template/widgets/app_buttons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppDialogType { success, error, confirmation }

class AppDialog extends StatelessWidget {
  final AppDialogType type;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final String cancelLabel;
  final VoidCallback onBack;
  final VoidCallback? onCancel;

  const AppDialog({
    super.key,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onBack,
    this.cancelLabel = 'Cancel',
    this.onCancel,
  });

  static const double _circleSize = 96;
  static const double _circleOverlap = _circleSize / 2;

  Color get _accentColor {
    switch (type) {
      case AppDialogType.success:
        return Colors.green;
      case AppDialogType.error:
        return Colors.red;
      case AppDialogType.confirmation:
        return Colors.blue;
    }
  }

  IconData get _icon {
    switch (type) {
      case AppDialogType.success:
        return Icons.check;
      case AppDialogType.error:
        return Icons.close;
      case AppDialogType.confirmation:
        return Icons.priority_high;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Material(
            color: Colors.white,
            elevation: 24,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 340),
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: 32,
                top: _circleOverlap + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  if (type == AppDialogType.confirmation)
                    Row(
                      children: [
                        Expanded(
                          child: AppButtons.outlinedButton(
                            context: context,
                            label: cancelLabel,
                            color: _accentColor,
                            onPressed: onCancel,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppButtons.filledButton(
                            context: context,
                            label: buttonLabel,
                            color: _accentColor,
                            onPressed: onBack,
                          ),
                        ),
                      ],
                    )
                  else
                    AppButtons.filledButton(
                      context: context,
                      label: buttonLabel,
                      color: _accentColor,
                      onPressed: onBack,
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            top: -_circleOverlap,
            child: Container(
              width: _circleSize,
              height: _circleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _accentColor,
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: Icon(
                _icon,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}