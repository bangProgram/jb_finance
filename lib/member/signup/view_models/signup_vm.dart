import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jb_finance/member/signup/models/signup_model.dart';
import 'package:jb_finance/member/signup/repos/signup_repo.dart';
import 'package:jb_finance/utils.dart';

class SignupVM extends AsyncNotifier<void> {
  late final SignupRepo _signupRepo;
  @override
  FutureOr<void> build() {
    _signupRepo = ref.read(signupRepo);
  }

  Future<void> createMember(
      BuildContext context, SignupModel signupModel) async {
    final result = await AsyncValue.guard(() async {
      return await _signupRepo.createMember(signupModel.toJson());
    });

    if (result.hasError) {
      throw Exception(result.error.toString());
    } else {
      final response = result.value!;
      serverMessage(context, response['message']);
    }
  }
}

final signupProvider = AsyncNotifierProvider<SignupVM, void>(
  () => SignupVM(),
);
