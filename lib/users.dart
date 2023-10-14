enum LoginPlatform {
  google,
  kakao,
  naver,
  none, // logout
}

class Users {
  static LoginPlatform loginPlatform = LoginPlatform.none;
}
