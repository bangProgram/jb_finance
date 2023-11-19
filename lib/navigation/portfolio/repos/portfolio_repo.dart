import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:jb_finance/consts.dart';
import 'package:jb_finance/keys.dart';

class PortfolioRepo {
  Future<Map<String, dynamic>> getPortAmount(String userId) async {
    final response = await http.post(
      Uri.parse("${Keys.forwardURL}/appApi/portfolio/getPortAmount"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({"userId": userId}),
    );

    print('response.statusCode : ${response.statusCode}');
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      return responseData;
    } else {
      throw Exception('사용자 포트폴리오 정보를 가져오지 못했습니다.');
    }
  }

  Future<bool> updatePortfolio(Map<String, dynamic> formData) async {
    final response = await http.post(
      Uri.parse("${Keys.forwardURL}/appApi/portfolio/updatePortfolio"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(formData),
    );

    print('response.statusCode : ${response.statusCode}');
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('사용자 포트폴리오 정보를 가져오지 못했습니다.');
    }
  }
}

final portfolioRepo = Provider((ref) => PortfolioRepo());
