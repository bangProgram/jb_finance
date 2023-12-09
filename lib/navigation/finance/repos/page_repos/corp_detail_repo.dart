import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:jb_finance/keys.dart';

class CorpDetailRepo {
  Future<List<dynamic>> getCorpReportList(Map<String, dynamic> param) async {
    final response = await http.post(
      Uri.parse("${Keys.forwardURL}/appApi/dart/reportList"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(param),
    );
    print('reponse1 : ${response.request}');
    if (response.statusCode == 200) {
      Map<String, dynamic> reportMap = json.decode(response.body);
      final List<dynamic> reportList = reportMap['dartReportList'];
      print('reportList : ${reportMap['dartReportList']}');
      return reportList;
    } else {
      throw Exception('리포트 불러오기 실패');
    }
  }

  Future<List<dynamic>> getCorpStockPrice(Map<String, dynamic> param) async {
    final response = await http.post(
      Uri.parse("${Keys.forwardURL}/appApi/report/getStockPrice"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(param),
    );

    print('reponse1 : ${response.request}');
    if (response.statusCode == 200) {
      Map<String, dynamic> cnadleData = json.decode(response.body);
      return cnadleData['value'];
    } else {
      throw Exception();
    }
  }

  Future<Map<String, dynamic>> getCorpPerform(
      Map<String, dynamic> param) async {
    final response = await http.post(
      Uri.parse("${Keys.forwardURL}/appApi/corp/perform"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(param),
    );

    print('reponse1 : ${response.request}');
    if (response.statusCode == 200) {
      Map<String, dynamic> resData = json.decode(response.body);
      return resData;
    } else {
      throw Exception('실적보고서를 불러오지 못했습니다.');
    }
  }

  Future<dynamic> getNaverNews(String corpCode) async {
    String newsURL =
        'https://m.stock.naver.com/api/news/stock/$corpCode?pageSize=40&page=1&searchMethod=title_entity_id.basic';
    Uri url = Uri.parse(newsURL);
    var response = await http.get(url);

    print('reponse1 : ${response.request}');
    if (response.statusCode == 200) {
      final newsDetail = jsonDecode(response.body);
      return newsDetail;
    } else {
      throw Exception('뉴스정보가 없습니다.');
    }
  }
}

final corpDetailRepo = Provider((ref) => CorpDetailRepo());
