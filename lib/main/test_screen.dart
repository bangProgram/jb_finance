import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jb_finance/main/test_model.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  Future<MainModel> fetchAlbum() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return MainModel.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<void> saveUser() async {
    print('함수는 들어왔다');

    final model = MainModel(
      text1: "test1",
      text2: "test2",
      text3: "text3",
      text4: "text4",
      text5: "text5",
    );

    print('함수는 들어왔다');
    try {
      print('response 들어간다');
      final response = await http.post(
        Uri.parse("http://192.168.148.221:8080/appApi/test"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(model.toJson()),
      );
      print('response 나왔다 ${response.statusCode}');
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        print("Server Response: $responseData");
        print("User Data sent successfully");
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception("Failed to send data");
      }
    } catch (e) {
      print("Failed to send post data: $e");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("테스트 메인화면"),
      ),
      body: Form(
        key: _globalKey,
        child: const Column(
            mainAxisAlignment: MainAxisAlignment.center, children: []),
      ),
    );
  }
}
