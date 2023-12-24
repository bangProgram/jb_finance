import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jb_finance/navigation/assetmanage/view_models/assetmanage_vm.dart';
import 'package:jb_finance/navigation/assetmanage/view_models/page_view_models/aseetmanage_page_vm.dart';
import 'package:jb_finance/navigation/finance/view_models/corporation_vm.dart';
import 'package:jb_finance/navigation/finance/view_models/interest_vm.dart';
import 'package:jb_finance/navigation/planbook/view_models/planbook_vm.dart';
import 'package:jb_finance/navigation/trade/view_models/trade_vm.dart';

void serverMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red.shade300,
      content: Center(child: Text(message)),
      duration: const Duration(seconds: 3),
    ),
  );
}

void successMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.green.shade300,
      content: Center(child: Text(message)),
      duration: const Duration(seconds: 3),
    ),
  );
}

String amountTrans(int value) {
  var format = NumberFormat.compact(locale: 'ko');
  var formatted = format.format(value);
  return formatted;
}

void focusOut(BuildContext context) {
  FocusScope.of(context).unfocus();
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

Future<void> login(AsyncNotifierProviderRef ref) async {
  ref.refresh(assetmanageProvider);
  ref.refresh(assetListProvider);
  ref.refresh(assetProportionProvider);
  ref.refresh(corpProvider);
  ref.refresh(interProvider);
  ref.refresh(planProvider);
  ref.refresh(tradeCorpListProvider);
  ref.refresh(tradeRecordProvider);

  print('vm 빌드 화면 초기화');
}
