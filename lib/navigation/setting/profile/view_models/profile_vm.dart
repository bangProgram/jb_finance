import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jb_finance/member/authentications.dart';
import 'package:jb_finance/member/login/repos/login_repo.dart';
import 'package:jb_finance/member/main/models/member_model.dart';

class ProfileVM extends AsyncNotifier<MemberModel> {
  late final Authentications _auth;
  late final LoginRepo _loginRepo;

  @override
  FutureOr<MemberModel> build() async {
    _auth = ref.read(authProvider);
    _loginRepo = ref.read(loginRepo);
    print('ProfileVM build : ${_auth.isLogin}');
    if (_auth.isLogin) {
      final userId = _auth.getUserId;
      final memberData = await _loginRepo.getMember(userId);
      print('memberData : $memberData');
      return MemberModel.fromJson(memberData);
    } else {
      return MemberModel.empty();
    }
  }
}

final profileVMProvider = AsyncNotifierProvider<ProfileVM, MemberModel>(
  () => ProfileVM(),
);
