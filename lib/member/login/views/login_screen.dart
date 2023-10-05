import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:jb_finance/member/signup/views/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "login";
  static const String routeURL = "/login";

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _pwEditController = TextEditingController();

  String _inputId = "";
  String _inputPw = "";
  bool _isSecure = true;

  Map<String, dynamic> member = {};

  void loginPressed() {
    if (_globalKey.currentState != null) {
      if (_globalKey.currentState!.validate()) {
        member['user_id'] = _inputId;
        member['password'] = _inputPw;
        memberLogin();
      }
    }
  }

  Future<void> memberLogin() async {
    final response = await http.post(
      Uri.parse("http://192.168.148.221:8080/appApi/member/login"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(member),
    );

    if (response.statusCode == 200) {
      print("User Data sent successfully");
    } else {
      throw Exception("Failed to send data");
    }
  }

  void goSignupScreen() {
    context.goNamed(SignupScreen.routeName);
  }

  @override
  void dispose() {
    _pwEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("로그인 화면"),
        ),
        body: Form(
          key: _globalKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 30,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: '아이디',
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 15,
                          ),
                        ),
                        onChanged: (value) {
                          _inputId = value;
                          setState(() {});
                        },
                      ),
                      TextFormField(
                        controller: _pwEditController,
                        obscureText: _isSecure,
                        decoration: InputDecoration(
                          hintText: '비밀번호',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 15,
                          ),
                          suffixIcon: _inputPw != ""
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        _isSecure = !_isSecure;
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.remove_red_eye_outlined,
                                        color: _isSecure
                                            ? Colors.black
                                            : Colors.grey,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _pwEditController.clear();
                                        _inputPw = _pwEditController.text;
                                        setState(() {});
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                )
                              : null,
                        ),
                        onChanged: (value) {
                          _inputPw = value;
                          setState(() {});
                        },
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('로그인'),
                      ),
                      TextButton(
                        onPressed: goSignupScreen,
                        child: const Text('회원가입'),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
