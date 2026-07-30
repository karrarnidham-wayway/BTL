import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/auth_provider.dart';
import '../../features/auth/login_screen.dart';
import '../../features/home/home_shell.dart';
import '../../features/store/product_detail_screen.dart';

/// Uygulamanın tek merkezi router'ı. Kullanıcının auth durumuna göre
/// otomatik yönlendirme yapar: giriş yapmamışsa /login'e, yapmışsa
/// role uygun ana ekrana (HomeShell içinde role göre farklı sekmeler).
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggedIn = authState.status == AuthStatus.authenticated;
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoggingIn) return '/login';
      if (isLoggedIn && isLoggingIn) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeShell()),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) => ProductDetailScreen(productId: state.pathParameters['id']!),
      ),
    ],
  );
});
