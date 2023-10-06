import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jb_finance/member/authentications.dart';
import 'package:jb_finance/member/login/views/login_screen.dart';
import 'package:jb_finance/main/main_screen.dart';
import 'package:jb_finance/member/signup/views/signup_screen.dart';

final routerProvider = Provider(
  (ref) => GoRouter(
    initialLocation: "/login",
    redirect: (context, state) async {
      final url = state.uri;
      final auth = ref.read(authProvider);
      print('로그인 확인 : ${auth.isLogin} / redirect uri : ${state.uri}');

      if (auth.isLogin) {
        // auth.refreshToken(token);
      }

      if (url != LoginScreen.routeURL && url != SignupScreen.routeURL) {
        if (auth.isLogin) {
          GoRoute(
            path: LoginScreen.routeURL,
            name: LoginScreen.routeName,
            builder: (context, state) => const LoginScreen(),
          );
        }
      }
      return null;
    },
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
