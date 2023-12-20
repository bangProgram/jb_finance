import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:jb_finance/keys.dart';

class UtilRepo {
  Future<Map<String, dynamic>> getYearList() async {
    final response = await http.get(
      Uri.parse("${Keys.forwardURL}/appApi/util/yearList"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      return responseData;
    } else {
      throw Exception('년도리스트 불러오기 실패');
    }
  }

  Future<String> getStockCode(String corpCode) async {
    final response = await http.post(
      Uri.parse("${Keys.forwardURL}/appApi/util/stockCode"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'pCorpCode': corpCode}),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      return responseData['stockCode'];
    } else {
      throw Exception('StockCode 불러오기 실패');
    }
  }
}

final utilRepo = Provider((ref) => UtilRepo());
