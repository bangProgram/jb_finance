import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:jb_finance/consts.dart';

class Authentications {
  static String? memberToken;
  static String memberId = "";
  bool get isLogin => memberToken != null;
  String get getUserId => memberToken == null ? "" : memberId;

  void removeToken() {
    memberToken = null;
    memberId = "";
  }

  Future<void> setToken({String? token, String? userId}) async {
    memberToken = token;
    if (userId != null) {
      memberId = userId;
    }
  }

  String? getToken() {
    return memberToken;
  }

  Future<void> refreshToken(String? token, String userId) async {
    final response = await http.post(
      Uri.parse("${Consts.mainUrl}/appApi/auth/refreshMember"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'token': token, 'userId': userId}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      final token = responseData['token'];
      setToken(token: token);
      print('refresh token message : ${responseData['message']}');
      print('refresh token : $token');
    } else {
      Map<String, dynamic> responseData = json.decode(response.body);
      throw Exception('${responseData['message']}');
    }
  }
}

final authProvider = Provider((ref) => Authentications());
