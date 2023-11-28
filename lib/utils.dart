import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void serverMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red.shade300,
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
