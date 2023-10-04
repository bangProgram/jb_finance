import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jb_finance/account/views/login_screen.dart';
import 'package:jb_finance/main/main_screen.dart';

final routerProvider = Provider(
  (ref) => GoRouter(
    initialLocation: "/main",
    routes: [
      GoRoute(
        path: "/login",
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: "/main",
        builder: (context, state) => const MainScreen(),
      ),
    ],
  ),
);
