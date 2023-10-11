import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jb_finance/router.dart';

void main() async {
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
        title: "JB_Finance",
        routerConfig: ref.watch(routerProvider),
      ),
    );
  }
}
