import 'package:drrew_template/providers/auth_provider.dart';
import 'package:drrew_template/providers/theme_provider.dart';
import 'package:drrew_template/widgets/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drrew Template'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
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
        ],
      ),
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
