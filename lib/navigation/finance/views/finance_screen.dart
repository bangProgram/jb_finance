import 'package:flutter/material.dart';

class FinanceScreen extends StatefulWidget {
  static const String routeName = "finance";
  static const String routeURL = "/finance";

  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('주식'),
      ),
    );
  }
}
