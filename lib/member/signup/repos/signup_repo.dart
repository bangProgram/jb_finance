import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:jb_finance/consts.dart';
import 'package:jb_finance/member/signup/models/signup_model.dart';

class SignupRepo {
  Future<Map<String, dynamic>> createMember(
      Map<String, dynamic> signupData) async {
    print('signupData : $signupData');
    final response = await http.post(
      Uri.parse("${Consts.mainUrl}/appApi/member/create"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(SignupModel.fromJson(signupData)),
    );

    print('response.statusCode : ${response.statusCode}');
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      return responseData;
    } else {
      throw Exception('회원가입에 실패했습니다.');
    }
  }
}

final signupRepo = Provider((ref) => SignupRepo());
