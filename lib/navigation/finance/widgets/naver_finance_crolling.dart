import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NaverFinanceCrolling extends StatelessWidget {
  const NaverFinanceCrolling({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: fetchStockPrice(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Text('네이버 증권 주가: ${snapshot.data}');
            }
          },
        ),
      ),
    );
  }
}

Future<String> fetchStockPrice() async {
  final response = await http.get(
      Uri.parse('https://finance.naver.com/sise/sise_index.nhn?code=KOSPI'));
  if (response.statusCode == 200) {
    final document = json.decode(response.body);
    final priceElement = document.querySelector('.num_quot > .num');
    return priceElement?.text ?? '주가를 찾을 수 없음';
  } else {
    throw Exception('Failed to load stock price');
  }
}
