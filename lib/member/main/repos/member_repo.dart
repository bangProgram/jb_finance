import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:jb_finance/consts.dart';
import 'package:jb_finance/member/main/models/member_model.dart';

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

  Future<MemberModel> updateMember(Map<String, dynamic> formData) async {
    final response = await http.post(
      Uri.parse("${Consts.mainUrl}/appApi/member/update"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(formData),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData['message']);
      return MemberModel.fromJson(responseData['memberData']);
    } else {
      throw Exception('사용자 정보 수정에 실패했습니다.');
    }
  }
}

final memberRepo = Provider((ref) => MemberRepo());
