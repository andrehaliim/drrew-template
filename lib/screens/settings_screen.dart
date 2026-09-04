// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(authControllerProvider).value?.email ?? '-';

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(child: Text('Logged in as $email')),
    );
  }
}