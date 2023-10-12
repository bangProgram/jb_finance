import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:jb_finance/consts.dart';

class ProfileRepo {
  Future<int> uploadAvatar(File file, String userId) async {
    final uploadFile = await http.MultipartFile.fromPath('file', file.path,
        filename: '${userId}_avatar.jpg');

    final request = http.MultipartRequest(
      'POST',
      Uri.parse("${Consts.mainUrl}/appApi/member/uploadAvatar"),
    );
    print('request : ${request.url.toString()}');
    request.files.add(uploadFile);
    request.fields['userId'] = userId;
    print('request send 직전');
    final response = await request.send();
    print('request send 이후');
    return response.statusCode;
  }
}

final profileRepo = Provider((ref) => ProfileRepo());
