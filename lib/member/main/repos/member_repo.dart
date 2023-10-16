import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:jb_finance/consts.dart';

class MemberRepo {
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
      Map<String, dynamic> resultData = {};
      return resultData;
    }
  }
}

final memberRepo = Provider((ref) => MemberRepo());
