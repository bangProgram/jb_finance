import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:jb_finance/keys.dart';

class CorporationRepo {
  Future<Map<String, dynamic>> getCorpList(Map<String, dynamic>? param) async {
    final response = await http.post(
      Uri.parse("${Keys.forwardURL}/appApi/corp/select"),
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
}

final corporationRepo = Provider((ref) => CorporationRepo());
