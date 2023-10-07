import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jb_finance/consts.dart';
import 'package:jb_finance/member/login/models/login_model.dart';
import 'package:http/http.dart' as http;

class LoginRepo {
  Future<Map<String, dynamic>> loginMember(LoginModel loginData) async {
    final response = await http.post(
      Uri.parse("${Consts.mainUrl}/appApi/member/login"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(loginData.toJson()),
    );
    Map<String, dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      print(responseData['memberData']);
      return responseData;
    } else {
      print(responseData['message']);
      throw Exception(responseData['message']);
    }
  }

  Future<Map<String, dynamic>> getMember(String userId) async {
    final response = await http.post(
      Uri.parse("${Consts.mainUrl}/appApi/member/getMember"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'userId': userId}),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> memberData = json.decode(response.body);
      return memberData;
    } else {
      throw Exception("Failed to send data");
    }
  }
}

final loginRepo = Provider((ref) => LoginRepo());
