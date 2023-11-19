import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:jb_finance/consts.dart';
import 'package:jb_finance/keys.dart';

class ProfileRepo {
  Future<int> uploadAvatar(File file, String userId) async {
    final uploadFile = await http.MultipartFile.fromPath('file', file.path,
        filename: '${userId}_avatar.jpeg');

    final request = http.MultipartRequest(
      'POST',
      Uri.parse("${Keys.forwardURL}/appApi/member/uploadAvatar"),
    );
    request.files.add(uploadFile);
    request.fields['userId'] = userId;
    final response = await request.send();
    return response.statusCode;
  }
}

final profileRepo = Provider((ref) => ProfileRepo());
