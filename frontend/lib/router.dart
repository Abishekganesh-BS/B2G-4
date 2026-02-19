import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/home/home_screen.dart';
import 'features/metabolic/metabolic_screen.dart';
import 'features/lifestyle/lifestyle_screen.dart';
import 'features/mental/mental_screen.dart';
import 'features/pediatric/pediatric_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'services/auth_service.dart';
import 'widgets/nav/glass_nav_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authServiceProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggedIn = authState.isLoggedIn;
      final isOnboarded = authState.isOnboarded;
      final currentPath = state.uri.path;

      // Not logged in → force to login (unless already on login/register)
      if (!isLoggedIn) {
        if (currentPath == '/login' || currentPath == '/register') return null;
        return '/login';
      }

      // Logged in but not onboarded → force to onboarding
      if (!isOnboarded) {
        if (currentPath == '/onboarding') return null;
        return '/onboarding';
      }

      // Logged in + onboarded but on auth pages → send to home
      if (currentPath == '/login' ||
          currentPath == '/register' ||
          currentPath == '/onboarding') {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            GlassNavShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/metabolic',
                builder: (context, state) => const MetabolicScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/lifestyle',
                builder: (context, state) => const LifestyleScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/mental',
                builder: (context, state) => const MentalWellBeingScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/pediatric',
                builder: (context, state) => const PediatricScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
