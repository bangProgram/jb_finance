enum LoginPlatform {
  google,
  kakao,
  naver,
  none, // logout
}

class Platforms {
  static LoginPlatform loginPlatform = LoginPlatform.none;

  static String accessDevice = '';
}
