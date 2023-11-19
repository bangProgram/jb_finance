import 'package:flutter/material.dart';

class NaverFinanceCrollingWeb extends StatefulWidget {
  const NaverFinanceCrollingWeb({super.key});

  @override
  State<NaverFinanceCrollingWeb> createState() =>
      _NaverFinanceCrollingWebState();
}

class _NaverFinanceCrollingWebState extends State<NaverFinanceCrollingWeb> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('네이버크롤링 웹'),
      ),
    );
  }
}
