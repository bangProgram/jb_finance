import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:jb_finance/keys.dart';

class InterestRepo {
  Future<Map<String, dynamic>> getCorpList(Map<String, dynamic>? param) async {
    final response = await http.post(
      Uri.parse("${Keys.forwardURL}/appApi/inter/select"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(param),
    );
    print('reponse : ${response.request}');
    if (response.statusCode == 200) {
      Map<String, dynamic> rsData = json.decode(response.body);
      return rsData;
    } else {
      throw Exception('기업조회 실패');
    }
  }

  Future<void> addInterest(Map<String, dynamic> param) async {
    final response = await http.post(
      Uri.parse("${Keys.forwardURL}/appApi/inter/add"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(param),
    );
    print('reponse : ${response.request}');
    if (response.statusCode == 200) {
    } else {
      throw Exception('관심종목 등록 실패');
    }
  }

  Future<void> delInterest(Map<String, dynamic> param) async {
    final response = await http.post(
      Uri.parse("${Keys.forwardURL}/appApi/inter/del"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(param),
    );
    print('reponse : ${response.request}');
    if (response.statusCode == 200) {
    } else {
      throw Exception('관심종목 삭제 실패');
    }
  }
}

final interestRepo = Provider((ref) => InterestRepo());
