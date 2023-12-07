import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:jb_finance/keys.dart';

class PlanbookRepo {
  Future<Map<String, dynamic>> getPlanbookList(
      Map<String, dynamic>? param) async {
    final response = await http.post(
      Uri.parse("${Keys.forwardURL}/appApi/planbook/list"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(param),
    );
    print('reponse : ${response.request}');
    if (response.statusCode == 200) {
      Map<String, dynamic> result = json.decode(response.body);
      return result;
    } else {
      throw Exception('목표관리 리스트 호출 실패');
    }
  }

  Future<Map<String, dynamic>> getPlanDetailInfo(
      Map<String, dynamic>? param) async {
    final response = await http.post(
      Uri.parse("${Keys.forwardURL}/appApi/planbook/detail"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(param),
    );
    print('reponse : ${response.request}');
    if (response.statusCode == 200) {
      Map<String, dynamic> result = json.decode(response.body);
      return result;
    } else {
      throw Exception('목표관리상세 기업정보 호출 실패');
    }
  }

  Future<Map<String, dynamic>> getPlanDetailMemo(
      Map<String, dynamic>? param) async {
    final response = await http.post(
      Uri.parse("${Keys.forwardURL}/appApi/planbook/memo"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(param),
    );
    print('reponse : ${response.request}');
    if (response.statusCode == 200) {
      Map<String, dynamic> result = json.decode(response.body);
      return result;
    } else {
      throw Exception('목표관리상세 메모 호출 실패');
    }
  }

  Future<Map<String, dynamic>> addPlanMemo(Map<String, dynamic> param) async {
    final response = await http.post(
      Uri.parse("${Keys.forwardURL}/appApi/planbook/memo/add"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(param),
    );
    print('reponse : ${response.request}');
    if (response.statusCode == 200) {
      Map<String, dynamic> result = json.decode(response.body);
      return result;
    } else {
      throw Exception('목표관리상세 메모 호출 실패');
    }
  }
}

final planbookRepo = Provider(
  (ref) => PlanbookRepo(),
);
