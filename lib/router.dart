import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jb_finance/member/authentications.dart';
import 'package:jb_finance/member/login/views/login_screen.dart';
import 'package:jb_finance/member/signup/views/signup_screen.dart';
import 'package:jb_finance/navigation/setting/profile/views/profile_screen.dart';
import 'package:jb_finance/navigation/views/navigation_screen.dart';

final routerProvider = Provider(
  (ref) => GoRouter(
    initialLocation: "/login",
    redirect: (context, state) async {
      final url = state.uri;
      final auth = ref.read(authProvider);
      print('로그인 확인 : ${auth.isLogin} / redirect uri : ${state.uri}');

      if (auth.isLogin) {
        final userId = auth.getUserId;
        final token = auth.getToken();
        print('로그인 사용자 아이디 : $userId');
        if (userId != "") {
          await auth.refreshToken(token, userId);
        } else {
          print('사용자 아이디 정보 없음');
        }
      }
      if (url.toString() != LoginScreen.routeURL &&
          url.toString() != SignupScreen.routeURL) {
        if (!auth.isLogin) {
          return LoginScreen.routeURL;
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
        path: SignupScreen.routeURL,
        name: SignupScreen.routeName,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/:tap(finance|portfolio|setting)',
        name: NavigationScreen.routeName,
        builder: (context, state) {
          final tap = state.pathParameters['tap'];
          if (tap != null) {
            return NavigationScreen(tap: tap);
          } else {
            print('네비게이션 이동 실패');
            return throw Exception('error occured');
          }
        },
      ),
      GoRoute(
        path: ProfileScreen.routeURL,
        name: ProfileScreen.routeName,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  ),
);
