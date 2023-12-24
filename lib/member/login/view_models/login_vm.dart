import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jb_finance/member/authentications.dart';
import 'package:jb_finance/member/login/models/login_model.dart';
import 'package:jb_finance/member/login/repos/login_repo.dart';
import 'package:jb_finance/member/login/views/login_screen.dart';
import 'package:jb_finance/member/main/models/member_model.dart';
import 'package:jb_finance/member/main/repos/member_repo.dart';
import 'package:jb_finance/member/signup/models/signup_model.dart';
import 'package:jb_finance/member/signup/repos/signup_repo.dart';
import 'package:jb_finance/navigation/finance/views/finance_screen.dart';
import 'package:jb_finance/navigation/setting/profile/view_models/profile_vm.dart';
import 'package:jb_finance/platforms.dart';
import 'package:jb_finance/utils.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class LoginVM extends AsyncNotifier<MemberModel> {
  late final Authentications _auth;
  late final LoginRepo _loginRepo;
  late final MemberRepo _memberRepo;
  late final SignupRepo _signupRepo;

  String message = "";

  @override
  FutureOr<MemberModel> build() async {
    _auth = ref.read(authProvider);
    _loginRepo = ref.read(loginRepo);
    _memberRepo = ref.read(memberRepo);
    _signupRepo = ref.read(signupRepo);

    if (_auth.isLogin) {
      final memberData = await _memberRepo.getMember(_auth.getUserId);
      return MemberModel.fromJson(memberData);
    }
    return MemberModel.empty();
  }

  Future<void> memberLogin(BuildContext context, LoginModel loginData) async {
    state = const AsyncValue.loading();
    late final String token;
    state = await AsyncValue.guard(() async {
      final responseData = await _loginRepo.loginMember(loginData);
      message = responseData['message'];
      final Map<String, dynamic> memberData = responseData["memberData"];
      token = responseData['token'];
      return MemberModel.fromJson(memberData);
    });

    if (state.hasError) {
      serverMessage(context, state.error.toString());
      return;
    } else {
      print('token 발급 세팅 : $token');
      final userId = loginData.userId;
      await _auth.setToken(token: token, userId: userId);
      // await _auth.setTokenForKisDev();
      ref.read(profileVMProvider.notifier).getMember();

      await login(ref);
      context.go(FinanceScreen.routeURL);
    }
  }

  Future<void> memberLogout(BuildContext context, WidgetRef ref) async {
    final platForm = Platforms.loginPlatform;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      print('platFrom : ${platForm.name} / ${platForm.name == 'kakao'}');
      if (platForm.name == 'kakao') {
        await UserApi.instance.logout();
      } else if (platForm.name == 'google') {
        await _googleSignIn.disconnect();
      } else if (platForm.name == 'naver') {
        await FlutterNaverLogin.logOut();
      }
      final responseData = await _loginRepo.logoutMember();
      return responseData;
    });

    if (state.hasError) {
      serverMessage(context, state.error.toString());
    } else {
      _auth.setToken(token: null);
      context.go(LoginScreen.routeURL);
    }
  }

  Future<void> signinWithNaver(BuildContext context) async {
    final NaverLoginResult result = await FlutterNaverLogin.logIn();

    if (result.status == NaverLoginStatus.loggedIn) {
      final NaverAccountResult accountData = result.account;
      final String userEmail = accountData.email;
      Platforms.loginPlatform = LoginPlatform.naver;

      final String password = '${Platforms.loginPlatform.name}$userEmail';
      //서버 사용자 유무 확인
      final serverUserData = await _memberRepo.getMember(userEmail);

      if (serverUserData.isEmpty) {
        //회원가입 모델 데이터 초기화
        final SignupModel signupModel = SignupModel(
            userId: userEmail,
            password: password,
            userName: accountData.name,
            avatarUrl: accountData.profileImage,
            platform: Platforms.loginPlatform.name);

        //초기화 한 회원가입모델 기준으로 회원등록 진행
        final createResult = await AsyncValue.guard(() async {
          return await _signupRepo.createMember(signupModel.toJson());
        });

        //회원 등록이 에러없이 정상으로 처리 되었으면 로그인 프로세스 진행
        if (createResult.hasError) {
          serverMessage(context, state.error.toString());
          return;
        } else {
          final String password = '${Platforms.loginPlatform.name}$userEmail';
          LoginModel loginData =
              LoginModel(userId: userEmail, password: password);
          await memberLogin(context, loginData);
        }
      } else {
        final String password = '${Platforms.loginPlatform.name}$userEmail';
        LoginModel loginData =
            LoginModel(userId: userEmail, password: password);
        await memberLogin(context, loginData);
      }
    } else {
      serverMessage(context, '네이버로그인에 실패했습니다.');
      return;
    }
  }

  Future<void> signinWithKAKAO(BuildContext context) async {
    late OAuthToken token;
    message = "";
    print('카카오1');
    if (await isKakaoTalkInstalled()) {
      print('카카오2');
      try {
        print('카카오2-1');
        token = await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공 ${token.accessToken}');
      } catch (error) {
        print('카카오3');
        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          print('카카오4');
          return;
        }
        print('카카오5');
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          print('카카오6');
          token = await UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공 ${token.accessToken}');
        } catch (error) {
          print('카카오7');
          serverMessage(context, '카카오 로그인에 실패했습니다.');
          return;
        }
        print('카카오8');
      }
    } else {
      print('카카오9');
      try {
        print('카카오10');
        token = await UserApi.instance.loginWithKakaoAccount();
      } catch (error) {
        print('카카오11');
        serverMessage(context, '카카오 로그인에 실패했습니다.');
        return;
      }
    }

    if (token.accessToken != '') {
      print('카카오12');
      try {
        print('카카오13');
        final response = await _loginRepo.loginWithKAKAO(token.accessToken);
        if (response.isNotEmpty) {
          print('카카오14');
          Platforms.loginPlatform = LoginPlatform.kakao;
          final accountData = response['kakao_account'];
          final userData = accountData['profile'];
          //해당 이메일이 기존에 회원가입 되어있는 사용자 인지 확인
          final userEmail = accountData['email'];
          final serverUserData = await _memberRepo.getMember(userEmail);

          //사용자 테이블에 회원이 존재하지 않으면 회원등록 프로세스 진행
          if (serverUserData.isEmpty) {
            print('카카오15');
            if (accountData['has_email'] == true) {
              print('카카오16');
              final String password =
                  '${Platforms.loginPlatform.name}$userEmail';
              //회원가입 모델 데이터 초기화
              final SignupModel signupModel = SignupModel(
                  userId: userEmail,
                  password: password,
                  userName: userData['nickname'],
                  avatarUrl: userData['profile_image_url'] ?? '',
                  platform: Platforms.loginPlatform.name);

              //초기화 한 회원가입모델 기준으로 회원등록 진행
              final createResult = await AsyncValue.guard(() async {
                print('카카오17');
                return await _signupRepo.createMember(signupModel.toJson());
              });

              //회원 등록이 에러없이 정상으로 처리 되었으면 로그인 프로세스 진행
              if (createResult.hasError) {
                print('카카오18');
                serverMessage(context, state.error.toString());
              } else {
                print('카카오19');
                final String password =
                    '${Platforms.loginPlatform.name}$userEmail';
                LoginModel loginData =
                    LoginModel(userId: userEmail, password: password);
                await memberLogin(context, loginData);
              }
            } else {
              print('카카오20');
              serverMessage(context, '카카오계정에 이메일 등록이 되지 않은경우\n카카오로그인이 불가능합니다.');
              return;
            }
          }
          //사용자 테이블에 회원이 존재하면 로그인 프로세스 진행
          else {
            print('카카오21');
            final String password = '${Platforms.loginPlatform.name}$userEmail';
            LoginModel loginData =
                LoginModel(userId: userEmail, password: password);
            await memberLogin(context, loginData);
          }
        } else {
          print('카카오22');
          serverMessage(context, '카카오 사용자정보 호출에 실패했습니다.');
          return;
        }
      } catch (error) {
        serverMessage(context, '$error');
        return;
      }
    }
  }

  Future<void> signinWithGoogle(BuildContext context) async {
    try {
      final googleUser = await _googleSignIn.signIn();
      //구글 사용자 로그인 정보가 있을경우 로그인/회원등록 프로세스 진행

      if (googleUser != null) {
        Platforms.loginPlatform = LoginPlatform.google;

        final userEmail = googleUser.email;

        final serverUserData = await _memberRepo.getMember(userEmail);

        //사용자 테이블에 회원이 존재하지 않으면 회원등록 프로세스 진행
        if (serverUserData.isEmpty) {
          final String password = '${Platforms.loginPlatform.name}$userEmail';
          print('google password : $password');
          //회원가입 모델 데이터 초기화
          final SignupModel signupModel = SignupModel(
              userId: userEmail,
              password: password,
              userName: googleUser.displayName ?? '미등록',
              avatarUrl: googleUser.photoUrl ?? '',
              platform: Platforms.loginPlatform.name);

          //초기화 한 회원가입모델 기준으로 회원등록 진행
          final createResult = await AsyncValue.guard(() async {
            return await _signupRepo.createMember(signupModel.toJson());
          });

          //회원 등록이 에러없이 정상으로 처리 되었으면 로그인 프로세스 진행
          if (createResult.hasError) {
            serverMessage(context, state.error.toString());
            return;
          } else {
            final String password = '${Platforms.loginPlatform.name}$userEmail';
            LoginModel loginData =
                LoginModel(userId: userEmail, password: password);
            await memberLogin(context, loginData);
          }
        }
        //사용자 테이블에 회원이 존재하면 로그인 프로세스 진행
        else {
          final String password = '${Platforms.loginPlatform.name}$userEmail';
          LoginModel loginData =
              LoginModel(userId: userEmail, password: password);
          await memberLogin(context, loginData);
        }
      }
    } catch (error) {
      serverMessage(context, '$error');
      print(error);
    }
  }
}

final loginVMProvider = AsyncNotifierProvider<LoginVM, MemberModel>(
  () => LoginVM(),
);
