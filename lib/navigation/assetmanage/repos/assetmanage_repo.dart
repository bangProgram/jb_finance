import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:jb_finance/consts.dart';
import 'package:jb_finance/keys.dart';

class AssetmanageRepo {
  Future<Map<String, dynamic>> getAssetAmount() async {
    final response = await http.post(
      Uri.parse("${Keys.forwardURL}/appApi/asset/amount"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({}),
    );

    print('vm 빌드 response.statusCode : ${response.request}');
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      return responseData;
    } else {
      throw Exception('사용자 포트폴리오 정보를 가져오지 못했습니다.');
    }
  }

  Future<Map<String, dynamic>> mergeAssetAmount(
      Map<String, dynamic> formData) async {
    final response = await http.post(
      Uri.parse("${Keys.forwardURL}/appApi/asset/merge"),
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
      throw Exception('사용자 포트폴리오 정보를 가져오지 못했습니다.');
    }
  }
}

final assetmanageRepo = Provider((ref) => AssetmanageRepo());
