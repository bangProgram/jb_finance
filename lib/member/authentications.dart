import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class Authentications {
  static String? memberToken;
  bool get isLogin => memberToken != null;

  void setToken(String token) {
    memberToken = token;
  }

  String? getToken() {
    return memberToken;
  }

  Future<void> refreshToken(String? token) async {
    print('refreshToken 들어옴 token : $token');
    final response = await http.post(
      Uri.parse("http://192.168.148.221:8080/appApi/member/auth"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'token': token}),
    );

    print('refreshToken 코드 확인 : ${response.statusCode}');
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      final token = responseData['token'];
      setToken(token);
    } else {
      throw Exception("Failed to send data");
    }
  }
}

final authProvider = Provider((ref) => Authentications());
