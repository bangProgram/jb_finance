import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jb_finance/member/login/views/login_screen.dart';
import 'package:jb_finance/main/main_screen.dart';
import 'package:jb_finance/member/signup/views/signup_screen.dart';

final routerProvider = Provider(
  (ref) => GoRouter(
    initialLocation: "/login",
    routes: [
      GoRoute(
        path: LoginScreen.routeURL,
        name: LoginScreen.routeName,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: "/main",
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: SignupScreen.routeURL,
        name: SignupScreen.routeName,
        builder: (context, state) => const SignupScreen(),
      ),
    ],
  ),
);
