import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jb_finance/keys.dart';
import 'package:jb_finance/router.dart';
import 'package:jb_finance/platforms.dart';

import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  KakaoSdk.init(
    nativeAppKey: Keys.nativeAppKeyForKAKAO,
    javaScriptAppKey: Keys.jsAppKeyForKAKAO,
  );

  runApp(
    const ProviderScope(
      child: JBFinance(),
    ),
  );
}

//메인화면에서 테스트
class JBFinance1 extends ConsumerWidget {
  const JBFinance1({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (kIsWeb) {
      Platforms.accessDevice = 'web';
    } else {
      TargetPlatform currentdevice = Theme.of(context).platform;
      if (currentdevice == TargetPlatform.android) {
        Platforms.accessDevice = 'android';
      } else if (currentdevice == TargetPlatform.iOS) {
        Platforms.accessDevice = 'ios';
      }
    }

    print('device : ${Platforms.accessDevice}');

    if (Platforms.accessDevice == '') {
      return MaterialApp(
        scrollBehavior: MyCustomScrollBehavior(),
        localizationsDelegates: const [
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Unsupported Platform'),
          ),
          body: const Center(
            child: Text('Sorry, this app is not supported on this platform.'),
          ),
        ),
      );
    } else {
      return SafeArea(
        child: MaterialApp.router(
          title: "주토피아",
          theme: ThemeData(
            fontFamily: 'Pretendard',
            colorScheme: const ColorScheme.light(background: Colors.white),
          ),
          routerConfig: ref.watch(routerProvider),
        ),
      );
    }
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}

mixin AppLocale {
  static const String title = 'title';
  static const String thisIs = 'thisIs';

  static const Map<String, dynamic> EN = {
    title: 'Localization',
    thisIs: 'This is %a package, version %a.',
  };

  static const Map<String, dynamic> KO = {
    title: '현지화',
    thisIs: '패키지 %a.',
  };
}

class JBFinance extends ConsumerStatefulWidget {
  const JBFinance({super.key});

  @override
  ConsumerState<JBFinance> createState() => _JBFinanceState();
}

class _JBFinanceState extends ConsumerState<JBFinance> {
  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      Platforms.accessDevice = 'web';
    } else {
      TargetPlatform currentdevice = Theme.of(context).platform;
      if (currentdevice == TargetPlatform.android) {
        Platforms.accessDevice = 'android';
      } else if (currentdevice == TargetPlatform.iOS) {
        Platforms.accessDevice = 'ios';
      }
    }

    print('device : ${Platforms.accessDevice}');

    if (Platforms.accessDevice == '') {
      return MaterialApp(
        scrollBehavior: MyCustomScrollBehavior(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ko', 'KR'),
        ],
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Unsupported Platform'),
          ),
          body: const Center(
            child: Text('Sorry, this app is not supported on this platform.'),
          ),
        ),
      );
    } else {
      return SafeArea(
        child: MaterialApp.router(
          title: "주토피아",
          theme: ThemeData(
            fontFamily: 'Pretendard',
            colorScheme: const ColorScheme.light(background: Colors.white),
          ),
          routerConfig: ref.watch(routerProvider),
        ),
      );
    }
  }
}
