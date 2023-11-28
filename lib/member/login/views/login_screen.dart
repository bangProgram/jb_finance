import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jb_finance/member/login/view_models/login_vm.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const String routeName = "login";
  static const String routeURL = "/login";

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final List<String> _imageList = [
    'assets/images/main_frame.png',
    'assets/images/main_logo_frame.png',
    'assets/images/main_logo.png',
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
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 40,
                horizontal: 30,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 55,
                  ),
                  SizedBox(
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          bottom: 50,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(_imageList[0]),
                              ),
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: 0.96,
                          child: Container(
                            width: 238,
                            height: 141,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(_imageList[1]),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 40,
                          bottom: 34,
                          child: Column(
                            children: [
                              const Text(
                                '누구나 누리는 주식',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SvgPicture.asset(
                                'assets/svgs/logos/Logo_jutopia_main.svg',
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 55,
                  ),
                  GestureDetector(
                    onTap: _signinWithKAKAO,
                    child: const SocialLoginBtnWidget(
                      btnColor: Color(0xFFFFED4B),
                      btnImage: 'assets/svgs/icons/Icon_kakao.svg',
                      btnText: '카카오톡으로 시작하기',
                      textColor: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  GestureDetector(
                    onTap: _signinWithGoogle,
                    child: const SocialLoginBtnWidget(
                      btnColor: Colors.white,
                      btnImage: 'assets/svgs/icons/Icon_google.svg',
                      btnText: '구글로 시작하기',
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
                      btnImage: 'assets/svgs/icons/Icon_naver.svg',
                      btnText: '네이버 계정으로 시작하기',
                      textColor: Colors.white,
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
          SvgPicture.asset(
            btnImage,
          ),
          const SizedBox(
            width: 16,
          ),
          Text(
            // onPressed: _signinWithGoogle,
            btnText,
            style: TextStyle(
              fontFamily: 'AppleSDGothicNeo',
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
