import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:jb_finance/consts.dart';
import 'package:jb_finance/keys.dart';

class Authentications {
  static String kisDevToken = "";
  static String? memberToken;
  static String memberId = "";

  bool get isLogin => memberToken != null;
  String get getKisDevToken => kisDevToken;
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
      Uri.parse("${Keys.forwardURL}/appApi/auth/refreshMember"),
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

  Future<void> setTokenForKisDev() async {
    final response = await http.post(
      Uri.parse("https://openapi.koreainvestment.com:9443/oauth2/tokenP"),
      body: jsonEncode({
        "grant_type": "client_credentials",
        "appkey": Keys.kisDeveloperAppKey,
        "appsecret": Keys.kisDeveloperAppSecretKey,
      }),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      kisDevToken = data['access_token'];
      print('정보 가져오기 성공 $kisDevToken');
    } else {
      throw Exception('KIS 토큰 발급 실패');
    }
  }
}

final authProvider = Provider((ref) => Authentications());
