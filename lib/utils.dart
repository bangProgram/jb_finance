import 'package:flutter/material.dart';

void serverMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
    ),
  );
}

void focusOut(BuildContext context) {
  FocusScope.of(context).unfocus();
}
