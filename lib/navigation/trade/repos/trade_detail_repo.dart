import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:jb_finance/keys.dart';

class TradeDetailRepo {
  Future<Map<String, dynamic>> addTradeCorpDetail(
      Map<String, dynamic> formData) async {
    final response = await http.post(
      Uri.parse("${Keys.forwardURL}/appApi/trade/corpDetail/add"),
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
      throw Exception('거래일지 작성에 실패했습니다.');
    }
  }
}

final tradeDetailRepo = Provider((ref) => TradeDetailRepo());
