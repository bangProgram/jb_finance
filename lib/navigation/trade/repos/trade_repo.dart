import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:jb_finance/keys.dart';

class TradeRepo {
  Future<Map<String, dynamic>> getTradeRecord(
      Map<String, dynamic> formData) async {
    final response = await http.post(
      Uri.parse("${Keys.forwardURL}/appApi/trade/record"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(formData),
    );

    print('response.statusCode : ${response.request}');
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      return responseData;
    } else {
      throw Exception('사용자 자산관리 정보를 가져오지 못했습니다.');
    }
  }

  Future<Map<String, dynamic>> getTradeCorpList() async {
    final response = await http.get(
      Uri.parse("${Keys.forwardURL}/appApi/trade/corpList"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print('response.statusCode : ${response.statusCode}');
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      return responseData;
    } else {
      throw Exception('사용자 자산관리 정보를 가져오지 못했습니다.');
    }
  }

  Future<Map<String, dynamic>> initTradeList() async {
    final response = await http.get(
      Uri.parse("${Keys.forwardURL}/appApi/trade/init"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print('reponse : ${response.request}');
    if (response.statusCode == 200) {
      Map<String, dynamic> rsData = json.decode(response.body);
      return rsData;
    } else {
      throw Exception('init 포트폴리오 리스트 불러오기 실패');
    }
  }

  Future<void> addTrade(Map<String, dynamic> param) async {
    final response = await http.post(
      Uri.parse("${Keys.forwardURL}/appApi/trade/add"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(param),
    );
    print('reponse : ${response.request}');
    if (response.statusCode == 200) {
    } else {
      throw Exception('포트폴리오 등록 실패');
    }
  }

  Future<void> delTrade(Map<String, dynamic> param) async {
    final response = await http.post(
      Uri.parse("${Keys.forwardURL}/appApi/trade/del"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(param),
    );
    print('reponse : ${response.request}');
    if (response.statusCode == 200) {
    } else {
      throw Exception('포트폴리오 삭제 실패');
    }
  }
}

final tradeRepo = Provider((ref) => TradeRepo());
