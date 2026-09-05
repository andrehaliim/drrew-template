import 'package:drrew_template/models/auth_state.dart';
import 'package:drrew_template/widgets/app_buttons.dart';
import 'package:drrew_template/widgets/app_dialogs.dart';
import 'package:drrew_template/widgets/app_textformfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  final _registerFormKey = GlobalKey<FormState>();
  final _regEmailController = TextEditingController();
  final _regPasswordController = TextEditingController();
  final _regNameController = TextEditingController();
  final _regNameFocus = FocusNode();
  final _regEmailFocus = FocusNode();
  final _regPasswordFocus = FocusNode();

  bool _isFieldFocused = false;
  bool _isRegister = false;

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(_handleFocusChange);
    _passwordFocus.addListener(_handleFocusChange);
    _regEmailFocus.addListener(_handleFocusChange);
    _regPasswordFocus.addListener(_handleFocusChange);
    _regNameFocus.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _regEmailController.dispose();
    _regPasswordController.dispose();
    _regNameController.dispose();

    _emailFocus.dispose();
    _passwordFocus.dispose();
    _regNameFocus.dispose();
    _regEmailFocus.dispose();
    _regPasswordFocus.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    final anyFocused = _emailFocus.hasFocus ||
        _passwordFocus.hasFocus ||
        _regNameFocus.hasFocus ||
        _regEmailFocus.hasFocus ||
        _regPasswordFocus.hasFocus;
    if (anyFocused != _isFieldFocused) {
      setState(() => _isFieldFocused = anyFocused);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final colorScheme = Theme.of(context).colorScheme;
    final authProvider = ref.watch(authControllerProvider);
    ref.listen<AsyncValue<AuthState>>(authControllerProvider, (previous, next) {
      if (next.value?.status == AuthStatus.error) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AppDialog(
            subtitle: next.value!.errorMessage ?? 'Something went wrong.',
            onBack: () {
              Navigator.of(context).pop();
            },
            type: AppDialogType.error,
            title: 'Login Failed',
            buttonLabel: 'OK',
          ),
        );
      }
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(color: colorScheme.primary),
          CustomPaint(
            painter: GridPainter(
              lineColor: colorScheme.onPrimary.withValues(alpha: 0.1),
              gridSize: 28,
            ),
            child: const SizedBox.expand(),
          ),
          Positioned(
            top: 0,
            bottom: _isRegister ? screenHeight * 0.65 : screenHeight * 0.55,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(28),
              decoration: const BoxDecoration(color: Colors.transparent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(),
                  SizedBox(height: 10),
                  Text(
                    'Drrew,\nApp Template.',
                    style: GoogleFonts.outfit(
                      fontSize: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.fontSize,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'This is my template app for upcoming projects',
                    style: GoogleFonts.inter(
                      fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            top: _isFieldFocused
                ? 0
                : _isRegister
                ? screenHeight * 0.35
                : screenHeight * 0.45,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.15),
                    blurRadius: 32,
                    offset: Offset(0, -8),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(28),
                child: _isRegister
                    ? _registerForm(authProvider)
                    : _loginForm(authProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Form _loginForm(AsyncValue<AuthState> provider) {
    final isLoading = provider.value?.status == AuthStatus.loading;
    final colorScheme = Theme.of(context).colorScheme;

    return Form(
      key: _loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Welcome Back',
            style: GoogleFonts.outfit(
              fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),

          Text(
            'Sign in to your workspace',
            style: GoogleFonts.inter(
              fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
              color: colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 24),

          AppTextFormField(
            label: 'Email Address',
            controller: _emailController,
            focusNode: _emailFocus,
            type: AppTextFieldType.email,
          ),

          const SizedBox(height: 16),

          AppTextFormField(
            label: 'Password',
            controller: _passwordController,
            focusNode: _passwordFocus,
            type: AppTextFieldType.password,
            labelTrailing: GestureDetector(
              onTap: () {},
              child: Text(
                'Forgot?',
                style: GoogleFonts.inter(
                  fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: AppButtons.filledButton(
              context: context,
              label: 'Sign in',
              isLoading: isLoading,
              trailing: const Text(
                '→',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              onPressed: () async {
                FocusScope.of(context).unfocus();
                setState(() => _isFieldFocused = false);
                if (_loginFormKey.currentState!.validate()) {
                  ref
                      .read(authControllerProvider.notifier)
                      .login(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      );
                }
              },
            ),
          ),

          const SizedBox(height: 16),

          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.inter(
                fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
                color: colorScheme.onSurfaceVariant,
              ),
              children: [
                TextSpan(text: 'Don\'t have an account? '),
                TextSpan(
                  text: 'Register',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      setState(() => _isRegister = true);
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Form _registerForm(AsyncValue<AuthState> provider) {
    final isLoading = provider.value?.status == AuthStatus.loading;
    final colorScheme = Theme.of(context).colorScheme;

    return Form(
      key: _registerFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Register',
            style: GoogleFonts.outfit(
              fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),

          Text(
            'Create a new account',
            style: GoogleFonts.inter(
              fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
              color: colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 24),

          AppTextFormField(
            label: 'Name',
            controller: _regNameController,
            focusNode: _regNameFocus,
            type: AppTextFieldType.normal,
          ),

          const SizedBox(height: 16),

          AppTextFormField(
            label: 'Email Address',
            controller: _regEmailController,
            focusNode: _regEmailFocus,
            type: AppTextFieldType.email,
          ),

          const SizedBox(height: 16),

          AppTextFormField(
            label: 'Password',
            controller: _regPasswordController,
            focusNode: _regPasswordFocus,
            type: AppTextFieldType.password,
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: AppButtons.filledButton(
              context: context,
              label: 'Register',
              isLoading: isLoading,
              trailing: const Text(
                '→',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              onPressed: () async {
                FocusScope.of(context).unfocus();
                setState(() => _isFieldFocused = false);
                if (_registerFormKey.currentState!.validate()) {
                  ref
                      .read(authControllerProvider.notifier)
                      .register(
                        email: _regEmailController.text.trim(),
                        password: _regPasswordController.text.trim(),
                        fullName: _regNameController.text.trim(),
                      );
                }
              },
            ),
          ),

          const SizedBox(height: 16),

          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.inter(
                fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
                color: colorScheme.onSurfaceVariant,
              ),
              children: [
                TextSpan(text: 'Already have an account? '),
                TextSpan(
                  text: 'Login',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      setState(() => _isRegister = false);
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final Color lineColor;
  final double gridSize;

  const GridPainter({
    this.lineColor = const Color(0xFF1a4a4a),
    this.gridSize = 32,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 1;

    for (double x = 0; x <= size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }

    for (double y = 0; y <= size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) =>
      oldDelegate.lineColor != lineColor || oldDelegate.gridSize != gridSize;
}