import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:jb_finance/member/login/views/login_screen.dart';

class SignupScreen extends StatefulWidget {
  static const String routeName = "signup";
  static const String routeURL = "/signup";
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _pwEditController = TextEditingController();

  String _password = "";

  bool _isSecure = true;

  Map<String, dynamic> memberData = {};

  void signupPressed() {
    final state = _globalKey.currentState;
    if (state != null) {
      if (state.validate()) {
        state.save();
        print('memberData : $memberData');
        createMember();
      }
    }
  }

  Future<void> createMember() async {
    final response = await http.post(
      Uri.parse("http://192.168.148.221:8080/appApi/member/create"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(memberData),
    );

    print('response : ${response.statusCode}');
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      print('사용자 가입 성공 : ${responseData['message']}');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('회원가입에 실패했습니다.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void goLoginScreen() {
    context.goNamed(LoginScreen.routeName);
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
          title: const Text('회원가입'),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height -
                AppBar().preferredSize.height,
            alignment: Alignment.center,
            child: Form(
              key: _globalKey,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: '아이디',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 15,
                        ),
                      ),
                      validator: (value) {
                        if (value == "") {
                          return '아이디는 필수값입니다';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        memberData['userId'] = newValue;
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
                        suffixIcon: _password != ""
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
                                      _password = _pwEditController.text;
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
                        _password = value;
                        setState(() {});
                      },
                      validator: (value) {
                        if (value == "" || value == null) {
                          return '비밀번호는 필수값입니다';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        memberData['password'] = newValue;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: '닉네임',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 15,
                        ),
                      ),
                      validator: (value) {
                        if (value == "" || value == null) {
                          return '닉네임은 필수값입니다';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        memberData['userNick'] = newValue;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: '이메일',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 15,
                        ),
                      ),
                      validator: (value) {
                        if (value == "" || value == null) {
                          return '이메일은 필수값입니다';
                        } else {
                          final bool emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value);

                          if (!emailValid) {
                            return '이메일 형식이 맞지않습니다';
                          }
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        memberData['email'] = newValue;
                      },
                    ),
                    TextButton(
                      onPressed: signupPressed,
                      child: const Text('회원가입'),
                    ),
                    TextButton(
                      onPressed: goLoginScreen,
                      child: const Text('로그인'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
