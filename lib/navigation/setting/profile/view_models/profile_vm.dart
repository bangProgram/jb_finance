import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jb_finance/member/authentications.dart';
import 'package:jb_finance/member/main/models/member_model.dart';
import 'package:jb_finance/member/main/repos/member_repo.dart';
import 'package:jb_finance/navigation/setting/profile/repos/profile_repo.dart';
import 'package:jb_finance/utils.dart';

class ProfileVM extends AsyncNotifier<MemberModel> {
  late final Authentications _auth;
  late final MemberRepo _memberRepo;
  late final ProfileRepo _profileRepo;

  @override
  FutureOr<MemberModel> build() async {
    _auth = ref.read(authProvider);
    _memberRepo = ref.read(memberRepo);
    _profileRepo = ref.read(profileRepo);
    print('ProfileVM build : ${_auth.isLogin}');
    if (_auth.isLogin) {
      final userId = _auth.getUserId;
      final memberData = await _memberRepo.getMember(userId);
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
      final result = await _profileRepo.uploadAvatar(file, userId);
      if (result == 200) {
        final memberData = await _memberRepo.getMember(userId);
        return MemberModel.fromJson(memberData);
      } else {
        throw Exception('upload Avatar error');
      }
    });
  }

  Future<void> getMember() async {
    final userId = _auth.getUserId;
    final memberData = await _memberRepo.getMember(userId);
    state = AsyncValue.data(MemberModel.fromJson(memberData));
  }

  Future<void> updateMember(
      BuildContext context, Map<String, dynamic> formData) async {
    state = const AsyncValue.loading();
    final userId = _auth.getUserId;
    final newFormData = {...formData, 'userId': userId};
    print('수정 정보 : $newFormData');
    state = await AsyncValue.guard(() async {
      return await _memberRepo.updateMember(newFormData);
    });

    if (state.hasError) {
      serverMessage(context, '${state.error}');
    }
  }
}

final profileVMProvider = AsyncNotifierProvider<ProfileVM, MemberModel>(
  () => ProfileVM(),
);
