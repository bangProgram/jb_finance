import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jb_finance/consts.dart';
import 'package:jb_finance/member/login/models/login_model.dart';
import 'package:http/http.dart' as http;
import 'package:jb_finance/member/main/models/member_model.dart';

class LoginRepo {
  Future<Map<String, dynamic>> loginMember(LoginModel loginData) async {
    final response = await http.post(
      Uri.parse("${Consts.mainUrl}/appApi/auth/loginPorc"),
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

  Future<MemberModel> logoutMember() async {
    final response = await http.post(
      Uri.parse("${Consts.mainUrl}/appApi/auth/logoutPorc"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({}),
    );
    if (response.statusCode == 200) {
      return MemberModel.empty();
    } else {
      throw Exception('로그아웃 실패');
    }
  }

  Future<Map<String, dynamic>> loginWithKAKAO(String token) async {
    try {
      final response = await http.get(
        Uri.parse("https://kapi.kakao.com/v2/user/me"),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(response.body);

        print('사용자 정보 가져오기 성공 $userData');
        return userData;
      } else {
        throw Exception('사용자 정보 가져오기 실패');
      }
    } catch (error) {
      throw Exception('사용자 정보 가져오기 실패');
    }
  }
}

final loginRepo = Provider((ref) => LoginRepo());
