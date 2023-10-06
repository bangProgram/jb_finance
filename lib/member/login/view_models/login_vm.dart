import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jb_finance/member/authentications.dart';
import 'package:jb_finance/member/login/models/login_model.dart';
import 'package:jb_finance/member/login/repos/login_repo.dart';
import 'package:jb_finance/member/main/models/member_model.dart';

class LoginVM extends AsyncNotifier<MemberModel> {
  late final Authentications _auth;
  late final LoginRepo _loginRepo;

  @override
  FutureOr<MemberModel> build() async {
    _auth = ref.read(authProvider);
    _loginRepo = ref.read(loginRepo);

    if (_auth.isLogin) {
      final memberData = await _loginRepo.getMember(_auth.getToken()!);
      return MemberModel.fromJson(memberData);
    }
    return MemberModel.empty();
  }

  Future<void> memberLogin(LoginModel loginData) async {
    state = const AsyncValue.loading();
    final responseData = await _loginRepo.loginMember(loginData);
    final Map<String, dynamic> memberData = responseData["memberData"];
    state = AsyncValue.data(MemberModel.fromJson(memberData));
  }
}

final loginVMProvider = AsyncNotifierProvider<LoginVM, MemberModel>(
  () => LoginVM(),
);
