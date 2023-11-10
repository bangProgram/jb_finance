import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jb_finance/member/login/view_models/login_vm.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const String routeName = "login";
  static const String routeURL = "/login";

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final int _currentImageIndex = 0;
  final List<String> _imageList = [
    'assets/images/backgrounds/login_background1.png',
    'assets/images/pepe.jpg',
  ];

  Future<void> _signinWithGoogle() async {
    await ref.read(loginVMProvider.notifier).signinWithGoogle(context);
  }

  void _signinWithKAKAO() async {
    await ref.read(loginVMProvider.notifier).signinWithKAKAO(context);
  }

  void _signinWithNaver() async {
    print('_signinWithNaver 들어감?');
    await ref.read(loginVMProvider.notifier).signinWithNaver(context);
    print('end');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final screenW = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(_imageList[_currentImageIndex]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 40,
                horizontal: 30,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: screenH * 0.3,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'ZU',
                            style: TextStyle(
                              letterSpacing: 6,
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(
                            text: ':',
                            style: TextStyle(
                              letterSpacing: 6,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(
                            text: 'topia',
                            style: TextStyle(
                              letterSpacing: 6,
                              fontSize: 44,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _signinWithKAKAO,
                    child: const SocialLoginBtnWidget(
                      btnColor: Color(0xFFFFED4B),
                      btnImage: 'assets/images/buttons/kakaoIcon.png',
                      btnText: '카카오톡으로 시작하기',
                      textColor: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  GestureDetector(
                    onTap: _signinWithNaver,
                    child: const SocialLoginBtnWidget(
                      btnColor: Color(0xFF03CF5D),
                      btnImage: 'assets/images/buttons/naverIcon.png',
                      btnText: '네이버 계정으로 시작하기',
                      textColor: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  GestureDetector(
                    onTap: _signinWithGoogle,
                    child: const SocialLoginBtnWidget(
                      btnColor: Colors.white,
                      btnImage: 'assets/images/buttons/google_login_btn.png',
                      btnText: 'Google 계정으로 로그인',
                      textColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SocialLoginBtnWidget extends StatelessWidget {
  final Color btnColor;
  final Color textColor;
  final String btnImage;
  final String btnText;

  const SocialLoginBtnWidget({
    super.key,
    required this.btnColor,
    required this.textColor,
    required this.btnImage,
    required this.btnText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 17,
      ),
      decoration: BoxDecoration(
        color: btnColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            btnImage,
            width: 24,
          ),
          const SizedBox(
            width: 16,
          ),
          Text(
            // onPressed: _signinWithGoogle,
            btnText,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
