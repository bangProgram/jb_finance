import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jb_finance/keys.dart';
import 'package:jb_finance/router.dart';

import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  KakaoSdk.init(
    nativeAppKey: Keys.nativeAppKeyForKAKAO,
    javaScriptAppKey: Keys.nativeAppKeyForKAKAO,
  );

  runApp(
    const ProviderScope(
      child: JBFinance(),
    ),
  );
}

class JBFinance extends ConsumerWidget {
  const JBFinance({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: MaterialApp.router(
        title: "주토피아",
        theme: ThemeData(
          fontFamily: 'AppleSDGothicNeo',
          colorScheme: const ColorScheme.light(background: Colors.white),
        ),
        routerConfig: ref.watch(routerProvider),
      ),
    );
  }
}
