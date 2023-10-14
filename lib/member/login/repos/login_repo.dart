import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jb_finance/Users.dart';
import 'package:jb_finance/consts.dart';
import 'package:jb_finance/member/login/models/login_model.dart';
import 'package:http/http.dart' as http;
import 'package:jb_finance/member/main/models/member_model.dart';

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

  Future<MemberModel> logoutMember() async {
    final responseData = MemberModel.empty();
    return responseData;
  }

  Future<String> loginWithKAKAO(String token) async {
    try {
      final response = await http.get(
        Uri.parse("https://kapi.kakao.com/v2/user/me"),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        Users.loginPlatform = LoginPlatform.kakao;
        final userData = response.body;

        print('사용자 정보 가져오기 성공 ${response.body}');
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
