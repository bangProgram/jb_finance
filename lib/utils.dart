import 'package:flutter/material.dart';

void serverMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red.shade300,
      content: Center(child: Text(message)),
      duration: const Duration(seconds: 3),
    ),
  );
}

void focusOut(BuildContext context) {
  FocusScope.of(context).unfocus();
}
