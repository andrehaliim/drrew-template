import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppTextFieldType { normal, email, password }

class AppTextFormField extends StatefulWidget {
  const AppTextFormField({
    super.key,
    required this.label,
    required this.controller,
    this.type = AppTextFieldType.normal,
    this.focusNode,
    this.hintText,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
    this.labelTrailing,
    this.maxLines = 1,
  });

  final String label;
  final TextEditingController controller;
  final AppTextFieldType type;
  final FocusNode? focusNode;
  final String? hintText;

  /// Override default validator kalau butuh custom rule.
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;

  /// Widget opsional di sebelah kanan label, contoh: link "Forgot?"
  final Widget? labelTrailing;
  final int maxLines;

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  late bool _obscureText = _isPassword;

  bool get _isPassword => widget.type == AppTextFieldType.password;

  TextInputType get _keyboardType {
    switch (widget.type) {
      case AppTextFieldType.email:
        return TextInputType.emailAddress;
      case AppTextFieldType.normal:
      case AppTextFieldType.password:
        return TextInputType.text;
    }
  }

  String? _defaultValidator(String? value) {
    switch (widget.type) {
      case AppTextFieldType.normal:
        if (value == null || value.trim().isEmpty) {
          return 'Fill this field';
        }
        return null;

      case AppTextFieldType.email:
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your email';
        }
        final emailRegex = RegExp(
          r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$',
        );
        if (!emailRegex.hasMatch(value.trim())) {
          return 'Enter a valid email address';
        }
        return null;

      case AppTextFieldType.password:
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelTrailing != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_label(context), widget.labelTrailing!],
          )
        else
          _label(context),

        const SizedBox(height: 8),

        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          obscureText: _isPassword && _obscureText,
          keyboardType: _keyboardType,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onFieldSubmitted,
          style: TextStyle(fontSize: 14, color: colorScheme.onSurface),
          maxLines: widget.maxLines,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.5,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.error, width: 1),
            ),
            errorStyle: TextStyle(fontSize: 12, color: colorScheme.error),
            suffixIcon: _isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscureText = !_obscureText),
                  )
                : null,
          ),
          validator: widget.validator ?? _defaultValidator,
        ),
      ],
    );
  }

  Text _label(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Text(
      widget.label,
      style: GoogleFonts.inter(
        fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
        color: colorScheme.onSurface,
      ),
    );
  }
}
