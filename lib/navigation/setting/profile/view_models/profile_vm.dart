import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jb_finance/member/authentications.dart';
import 'package:jb_finance/member/login/repos/login_repo.dart';
import 'package:jb_finance/member/main/models/member_model.dart';
import 'package:jb_finance/navigation/setting/profile/repos/profile_repo.dart';

class ProfileVM extends AsyncNotifier<MemberModel> {
  late final Authentications _auth;
  late final LoginRepo _loginRepo;
  late final ProfileRepo _profileRepo;

  @override
  FutureOr<MemberModel> build() async {
    _auth = ref.read(authProvider);
    _loginRepo = ref.read(loginRepo);
    _profileRepo = ref.read(profileRepo);
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

  Future<void> uploadAvatar(File file) async {
    final userId = _auth.getUserId;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      print('profileVM uploadAvatar 진입');
      final result = await _profileRepo.uploadAvatar(file, userId);
      print('result code : $result');
      if (result == 200) {
        final memberData = await _loginRepo.getMember(userId);
        return MemberModel.fromJson(memberData);
      } else {
        throw Exception('upload Avatar error');
      }
    });
  }

  Future<void> getMember() async {
    final userId = _auth.getUserId;
    final memberData = await _loginRepo.getMember(userId);
    state = AsyncValue.data(MemberModel.fromJson(memberData));
  }
}

final profileVMProvider = AsyncNotifierProvider<ProfileVM, MemberModel>(
  () => ProfileVM(),
);
