import 'package:drrew_template/widgets/app_messenger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'providers/theme_provider.dart';
import 'config/env/env.dart';

void bootstrap() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeAsync = ref.watch(themeModeControllerProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: _titleByFlavor(),
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeModeAsync.value ?? ThemeMode.system,
      routerConfig: router,
      scaffoldMessengerKey: scaffoldMessengerKey,
    );
  }

  String _titleByFlavor() {
    return switch (Env.flavor) {
      AppFlavor.dev => 'Drrew Template DEV',
      AppFlavor.staging => 'Drrew Template STG',
      AppFlavor.prod => 'Drrew Template',
    };
  }
}