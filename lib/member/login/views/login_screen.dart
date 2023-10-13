import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jb_finance/member/login/models/login_model.dart';
import 'package:jb_finance/member/login/view_models/login_vm.dart';
import 'package:jb_finance/member/signup/views/signup_screen.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: 'your-client_id.apps.googleusercontent.com',
  scopes: ['email'],
);

enum LoginPlatform {
  google,
  kakao,
  naver,
  none, // logout
}

class LoginScreen extends ConsumerStatefulWidget {
  static const String routeName = "login";
  static const String routeURL = "/login";

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _pwEditController = TextEditingController();

  late LoginModel _loginData;

  String _userId = "";
  String _password = "";
  bool _isSecure = true;

  LoginPlatform _loginPlatform = LoginPlatform.none;

  Future<void> _handleSignIn() async {
    try {
      final googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        print('name = ${googleUser.displayName}');
        print('email = ${googleUser.email}');
        print('id = ${googleUser.id}');
        print('googleUser = ${googleUser.authentication.toString()}');

        setState(() {
          _loginPlatform = LoginPlatform.google;
        });
      }
    } catch (error) {
      print(error);
    }
  }

  void signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      print('name = ${googleUser.displayName}');
      print('email = ${googleUser.email}');
      print('id = ${googleUser.id}');
      print('googleUser = ${googleUser.authentication.toString()}');

      setState(() {
        _loginPlatform = LoginPlatform.google;
      });
    }
  }

  Future<void> _signOutWithGoogle() async {
    try {
      await _googleSignIn.disconnect();
    } catch (error) {
      print(error);
    }
  }

  void loginPressed() async {
    final state = _globalKey.currentState;

    if (state != null) {
      if (state.validate()) {
        state.save();
        _loginData = LoginModel(userId: _userId, password: _password);
        await ref
            .read(loginVMProvider.notifier)
            .memberLogin(context, _loginData);
      }
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
                          _userId = value;
                        },
                        validator: (value) {
                          if (value == "") {
                            return '아이디는 필수값입니다';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _userId = newValue!;
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
                          if (value == "") {
                            return '비밀번호는 필수값입니다';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _password = newValue!;
                        },
                      ),
                      TextButton(
                        onPressed: loginPressed,
                        child: const Text('로그인'),
                      ),
                      TextButton(
                        onPressed: goSignupScreen,
                        child: const Text('회원가입'),
                      ),
                      TextButton(
                        onPressed: _handleSignIn,
                        child: const Text('구글로그인'),
                      ),
                      TextButton(
                        onPressed: _signOutWithGoogle,
                        child: const Text('구글로그아웃'),
                      ),
                      TextButton(
                        onPressed: _handleSignIn,
                        child: const Text('카카오로그인'),
                      ),
                      TextButton(
                        onPressed: _signOutWithGoogle,
                        child: const Text('카카오로그아웃'),
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
