import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jb_finance/keys.dart';

class AssetmanagePageRepo {
  Future<Map<String, dynamic>> getAssetList() async {
    final response = await http.get(
      Uri.parse("${Keys.forwardURL}/appApi/asset/list"),
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

  Future<Map<String, dynamic>> getAssetProportion(
      Map<String, dynamic> formData) async {
    final response = await http.post(
      Uri.parse("${Keys.forwardURL}/appApi/asset/proportion"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(formData),
    );

    print('response.statusCode : ${response.statusCode}');
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      return responseData;
    } else {
      throw Exception('사용자 자산관리 비중정보를 가져오지 못했습니다.');
    }
  }
}

final assetmanagePageRepo = Provider((ref) => AssetmanagePageRepo());
