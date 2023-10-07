import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jb_finance/member/authentications.dart';
import 'package:jb_finance/member/login/models/login_model.dart';
import 'package:jb_finance/member/login/repos/login_repo.dart';
import 'package:jb_finance/member/main/models/member_model.dart';
import 'package:jb_finance/navigation/profile/views/portfolio_screen.dart';
import 'package:jb_finance/utils.dart';

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
}

final loginVMProvider = AsyncNotifierProvider<LoginVM, MemberModel>(
  () => LoginVM(),
);
