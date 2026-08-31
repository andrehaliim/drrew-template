import 'package:drrew_template/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Drrew Template')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ref.read(themeModeControllerProvider.notifier).toggle();
          },
          child: const Text('Toggle Theme'),
        ),
      ),
    );
  }
}