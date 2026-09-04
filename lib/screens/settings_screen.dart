// lib/screens/settings_screen.dart
import 'package:drrew_template/widgets/app_buttons.dart';
import 'package:drrew_template/widgets/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(authControllerProvider).value?.email ?? '-';
    final themeModeAsync = ref.watch(themeModeControllerProvider);
    final currentMode = themeModeAsync.value ?? ThemeMode.system;
    final isDark = currentMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Center(child: Text('Logged in as $email')),
          const SizedBox(height: 24),
          const Divider(height: 1),
          ListTile(
            leading: _AnimatedThemeIcon(isDark: isDark),
            title: const Text('Dark Mode'),
            subtitle: Text(_modeLabel(currentMode)),
            trailing: Switch(
              value: isDark,
              onChanged: (_) {
                ref.read(themeModeControllerProvider.notifier).toggle();
              },
            ),
            onTap: () {
              ref.read(themeModeControllerProvider.notifier).toggle();
            },
          ),
          const Divider(height: 1),
          Spacer(),
          Container(
            margin: EdgeInsets.all(16),
            height: 52,
            child: AppButtons.filledButton(
              context: context,
              label: 'Logout',
              trailing: Icon(Icons.logout),
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AppDialog(
                    subtitle: "Are you sure you want to logout?",
                    onBack: () {
                      Navigator.of(context).pop();
                      ref.read(authControllerProvider.notifier).logout();
                    },
                    type: AppDialogType.confirmation,
                    title: 'Logout',
                    buttonLabel: 'Yes',
                    onCancel: () {
                      Navigator.of(context).pop();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _modeLabel(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => 'Light',
      ThemeMode.dark => 'Dark',
      ThemeMode.system => 'System',
    };
  }
}

class _AnimatedThemeIcon extends StatelessWidget {
  const _AnimatedThemeIcon({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      transitionBuilder: (child, animation) {
        final rotate = Tween<double>(begin: 0.75, end: 1.0).animate(animation);
        return RotationTransition(
          turns: rotate,
          child: ScaleTransition(
            scale: animation,
            child: FadeTransition(opacity: animation, child: child),
          ),
        );
      },
      switchInCurve: Curves.easeOutBack,
      switchOutCurve: Curves.easeIn,
      child: Icon(
        isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
        key: ValueKey<bool>(isDark),
        color: isDark ? Colors.indigo[200] : Colors.orange,
        size: 28,
      ),
    );
  }
}
