class SignupModel {
  final String userId;
  final String password;
  final String userName;
  final String avatarUrl;
  final String platform;

  SignupModel({
    required this.userId,
    required this.password,
    required this.userName,
    required this.avatarUrl,
    required this.platform,
  });

  SignupModel.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        password = json['password'],
        userName = json['userName'],
        avatarUrl = json['avatarUrl'],
        platform = json['platform'];

  SignupModel.empty()
      : userId = "",
        password = "",
        userName = "",
        avatarUrl = "",
        platform = "";

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'password': password,
      'userName': userName,
      'avatarUrl': avatarUrl,
      'platform': platform,
    };
  }
}
