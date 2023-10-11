import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jb_finance/member/authentications.dart';
import 'package:jb_finance/member/login/repos/login_repo.dart';

class SettingVM extends AsyncNotifier<void> {
  late final Authentications _auth;
  late final LoginRepo _loginRepo;

  @override
  FutureOr<void> build() {}
}

final settingVMProvider = AsyncNotifierProvider<SettingVM, void>(
  () => SettingVM(),
);
