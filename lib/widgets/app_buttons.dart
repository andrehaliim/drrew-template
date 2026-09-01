import 'package:flutter/material.dart';

class AppButtons {
  static Widget filledButton({
    required BuildContext context,
    required String label,
    required VoidCallback? onPressed,
    bool isLoading = false,
    Widget? trailing,
    Widget? leading,
    Color? color,
    double height = 50,
    double borderRadius = 12,
  }) {
    final resolvedColor = color ?? Theme.of(context).primaryColor;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: resolvedColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: _content(
          context: context,
          label: label,
          isLoading: isLoading,
          textColor: Colors.white,
          trailing: trailing,
          leading: leading,
        ),
      ),
    );
  }

  static Widget outlinedButton({
    required BuildContext context,
    required String label,
    required VoidCallback? onPressed,
    bool isLoading = false,
    Widget? trailing,
    Widget? leading,
    Color? color,
    double height = 50,
    double borderRadius = 12,
  }) {
    final resolvedColor = color ?? Theme.of(context).primaryColor;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: resolvedColor, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: _content(
          context: context,
          label: label,
          isLoading: isLoading,
          textColor: resolvedColor,
          trailing: trailing,
          leading: leading,
        ),
      ),
    );
  }

  static Widget _content({
    required BuildContext context,
    required String label,
    required bool isLoading,
    required Color textColor,
    Widget? trailing,
    Widget? leading,
  }) {
    final fontSize = Theme.of(context).textTheme.bodyLarge?.fontSize;

    if (isLoading) {
      return SizedBox(
        height: 16,
        width: 16,
        child: CircularProgressIndicator(color: textColor, strokeWidth: 2),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leading != null) ...[leading, const SizedBox(width: 8)],
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 8), trailing],
      ],
    );
  }
}