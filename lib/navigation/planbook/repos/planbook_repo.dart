import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:jb_finance/keys.dart';

class PlanbookRepo {
  //목표관리화면 기간별 기업리스트 가져오기
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

  //목표관리상세화면 기업 정보 가져오기
  Future<Map<String, dynamic>> getPlanDetailInfo(
      Map<String, dynamic>? param) async {
    final response = await http.post(
      Uri.parse("${Keys.forwardURL}/appApi/planbook/info"),
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

  //목표관리상세화면 메모 가져오기
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

  //목표관리상세화면 메모 등록
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
      throw Exception('목표관리상세 메모 등록 실패');
    }
  }

  //목표관리상세화면 메모 삭제
  Future<Map<String, dynamic>> delPlanMemo(Map<String, dynamic> param) async {
    final response = await http.post(
      Uri.parse("${Keys.forwardURL}/appApi/planbook/memo/del"),
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
      throw Exception('목표관리상세 메모 삭제 실패');
    }
  }

  Future<Map<String, dynamic>> mergePlaninfo(Map<String, dynamic> param) async {
    final response = await http.post(
      Uri.parse("${Keys.forwardURL}/appApi/planbook/info/cud"),
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
      throw Exception('목표관리상세 기업정보 merge 실패');
    }
  }

  Future<Map<String, dynamic>> getNaverData1(String stockCode) async {
    final response = await http.get(
      Uri.parse(
          "https://navercomp.wisereport.co.kr/company/chart/c1030001.aspx?cmp_cd=$stockCode&rpt=6&finGubun=MAIN&frq=Y&chartType="),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print('reponse : ${response.request}');
    if (response.statusCode == 200) {
      Map<String, dynamic> result = json.decode(response.body);
      return result;
    } else {
      throw Exception('getNaverData1 Loading 실패');
    }
  }
}

final planbookRepo = Provider(
  (ref) => PlanbookRepo(),
);
