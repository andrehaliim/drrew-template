import 'package:drrew_template/screens/main_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/auth_state.dart';
import '../providers/auth_provider.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/splash_screen.dart';
import 'app_routes.dart';
import 'router_refresh_notifier.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final refreshNotifier = RouterRefreshNotifier(ref);
  ref.onDispose(refreshNotifier.dispose);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refreshNotifier,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
    ],
    redirect: (context, state) {
      final authAsync = ref.read(authControllerProvider);
      final currentLocation = state.matchedLocation;
      final isLoggingIn = currentLocation == AppRoutes.login;
      final isSplash = currentLocation == AppRoutes.splash;

      // Belum ada value sama sekali (initial token check di build())
      // -> ini SATU-SATUNYA kondisi yang trigger splash.
      if (!authAsync.hasValue) {
        return isSplash ? null : AppRoutes.splash;
      }

      final status = authAsync.value!.status;
      final isLoggedOut =
          status == AuthStatus.unauthenticated || status == AuthStatus.error;

      // status == AuthStatus.loading (saat submit login/register) TIDAK
      // memicu splash lagi -- itu urusan tombol di LoginScreen.
      if (isLoggedOut) {
        return isLoggingIn ? null : AppRoutes.login;
      }

      if (status == AuthStatus.authenticated) {
        if (isLoggingIn || isSplash) {
          return AppRoutes.home;
        }
      }

      return null;
    },
  );
}