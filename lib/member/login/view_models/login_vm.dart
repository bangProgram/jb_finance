import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jb_finance/member/authentications.dart';
import 'package:jb_finance/member/login/models/login_model.dart';
import 'package:jb_finance/member/login/repos/login_repo.dart';
import 'package:jb_finance/member/login/views/login_screen.dart';
import 'package:jb_finance/member/main/models/member_model.dart';
import 'package:jb_finance/navigation/portfolio/views/portfolio_screen.dart';
import 'package:jb_finance/utils.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class LoginVM extends AsyncNotifier<MemberModel> {
  late final Authentications _auth;
  late final LoginRepo _loginRepo;

  @override
  FutureOr<MemberModel> build() async {
    _auth = ref.read(authProvider);
    _loginRepo = ref.read(loginRepo);

    if (_auth.isLogin) {
      final memberData = await _loginRepo.getMember(_auth.getUserId);
      return MemberModel.fromJson(memberData);
    }
    return MemberModel.empty();
  }

  Future<void> memberLogin(BuildContext context, LoginModel loginData) async {
    state = const AsyncValue.loading();
    String message = "";
    late final String token;
    state = await AsyncValue.guard(() async {
      final responseData = await _loginRepo.loginMember(loginData);
      message = responseData['message'];
      final Map<String, dynamic> memberData = responseData["memberData"];
      print('member Login Success? ${responseData['message']}');
      token = responseData['token'];
      return MemberModel.fromJson(memberData);
    });

    if (state.hasError) {
      serverMessage(context, state.error.toString());
    } else {
      print('token 발급 세팅 : $token');
      _auth.setToken(token: token, userId: loginData.userId);
      context.go(PortfolioScreen.routeURL);
    }
  }

  Future<void> memberLogout(BuildContext context) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final responseData = await _loginRepo.logoutMember();
      return responseData;
    });

    if (state.hasError) {
      serverMessage(context, state.error.toString());
    } else {
      _auth.setToken(token: null);
      context.go(LoginScreen.routeURL);
    }
  }

  Future<void> signinWithKAKAO(BuildContext context) async {
    late OAuthToken token;
    if (await isKakaoTalkInstalled()) {
      try {
        token = await UserApi.instance.loginWithKakaoTalk();
      } catch (error) {
        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          token = await UserApi.instance.loginWithKakaoAccount();
        } catch (error) {
          serverMessage(context, '카카오 로그인에 실패했습니다.');
        }
      }
    } else {
      try {
        token = await UserApi.instance.loginWithKakaoAccount();
      } catch (error) {
        serverMessage(context, '카카오 로그인에 실패했습니다.');
      }
    }

    if (token.accessToken != '') {
      final userData = await AsyncValue.guard(() async {
        return await _loginRepo.loginWithKAKAO(token.accessToken);
      });
      if (userData.hasError) {
        print(userData);
      }
    }
  }
}

final loginVMProvider = AsyncNotifierProvider<LoginVM, MemberModel>(
  () => LoginVM(),
);
