import 'package:drrew_template/models/auth_state.dart';
import 'package:drrew_template/widgets/app_buttons.dart';
import 'package:drrew_template/widgets/app_dialogs.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _obscurePassword = true;
  bool _isFieldFocused = false;
  bool _isRegister = false;

  @override
  void initState() {
    super.initState();
    _nameFocus.addListener(_handleFocusChange);
    _emailFocus.addListener(_handleFocusChange);
    _passwordFocus.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    final anyFocused =
        _nameFocus.hasFocus || _emailFocus.hasFocus || _passwordFocus.hasFocus;
    if (anyFocused != _isFieldFocused) {
      setState(() => _isFieldFocused = anyFocused);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
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
          Container(color: Theme.of(context).primaryColor),
          CustomPaint(
            painter: GridPainter(
              lineColor: Colors.white.withValues(alpha: 0.1),
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
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'This is my template app for upcoming projects',
                    style: GoogleFonts.inter(
                      fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
                      color: Colors.white,
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
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
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

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Welcome Back',
            style: GoogleFonts.outfit(
              fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),

          Text(
            'Sign in to your workspace',
            style: GoogleFonts.inter(
              fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
              color: Colors.black.withValues(alpha: 0.5),
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Email Address',
            style: GoogleFonts.inter(
              fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 8),

          TextFormField(
            controller: _emailController,
            focusNode: _emailFocus,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
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
                borderSide: const BorderSide(
                  color: Color(0xFF1A1A1A),
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.redAccent,
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.redAccent,
                  width: 1.5,
                ),
              ),
              errorStyle: const TextStyle(
                fontSize: 12,
                color: Colors.redAccent,
              ),
            ),
            validator: (value) {
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
            },
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Password',
                style: GoogleFonts.inter(
                  fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Forgot?',
                  style: GoogleFonts.inter(
                    fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            focusNode: _passwordFocus,
            style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
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
                borderSide: const BorderSide(
                  color: Color(0xFF1A1A1A),
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.redAccent,
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.redAccent,
                  width: 1.5,
                ),
              ),
              errorStyle: const TextStyle(
                fontSize: 12,
                color: Colors.redAccent,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: const Color(0xFF9E9E9E),
                  size: 20,
                ),
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
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
                if (_formKey.currentState!.validate()) {
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
                color: Colors.black.withValues(alpha: 0.5),
              ),
              children: [
                TextSpan(text: 'Don\'t have an account? '),
                TextSpan(
                  text: 'Register',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
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

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Register',
            style: GoogleFonts.outfit(
              fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),

          Text(
            'Create a new account',
            style: GoogleFonts.inter(
              fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
              color: Colors.black.withValues(alpha: 0.5),
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Name',
            style: GoogleFonts.inter(
              fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 8),

          TextFormField(
            controller: _nameController,
            focusNode: _nameFocus,
            style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
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
                borderSide: const BorderSide(
                  color: Color(0xFF1A1A1A),
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.redAccent,
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.redAccent,
                  width: 1.5,
                ),
              ),
              errorStyle: const TextStyle(
                fontSize: 12,
                color: Colors.redAccent,
              ),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            'Email Address',
            style: GoogleFonts.inter(
              fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 8),

          TextFormField(
            controller: _emailController,
            focusNode: _emailFocus,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
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
                borderSide: const BorderSide(
                  color: Color(0xFF1A1A1A),
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.redAccent,
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.redAccent,
                  width: 1.5,
                ),
              ),
              errorStyle: const TextStyle(
                fontSize: 12,
                color: Colors.redAccent,
              ),
            ),
            validator: (value) {
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
            },
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Password',
                style: GoogleFonts.inter(
                  fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Forgot?',
                  style: GoogleFonts.inter(
                    fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            focusNode: _passwordFocus,
            style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
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
                borderSide: const BorderSide(
                  color: Color(0xFF1A1A1A),
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.redAccent,
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.redAccent,
                  width: 1.5,
                ),
              ),
              errorStyle: const TextStyle(
                fontSize: 12,
                color: Colors.redAccent,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: const Color(0xFF9E9E9E),
                  size: 20,
                ),
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
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
                if (_formKey.currentState!.validate()) {
                  ref
                      .read(authControllerProvider.notifier)
                      .register(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                        fullName: _nameController.text.trim(),
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
                color: Colors.black.withValues(alpha: 0.5),
              ),
              children: [
                TextSpan(text: 'Already have an account? '),
                TextSpan(
                  text: 'Login',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
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
