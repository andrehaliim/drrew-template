import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/auth_status.dart';
import '../providers/auth_provider.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import 'app_routes.dart';
import 'router_refresh_notifier.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final refreshNotifier = RouterRefreshNotifier(ref);
  ref.onDispose(refreshNotifier.dispose);

  return GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: refreshNotifier,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
    ],
    redirect: (context, state) {
      final authStatus = ref.read(authControllerProvider);
      final isLoggingIn = state.matchedLocation == AppRoutes.login;

      if (authStatus == AuthStatus.unknown) return null;

      if (authStatus == AuthStatus.unauthenticated && !isLoggingIn) {
        return AppRoutes.login;
      }

      if (authStatus == AuthStatus.authenticated && isLoggingIn) {
        return AppRoutes.home;
      }

      return null;
    },
  );
}