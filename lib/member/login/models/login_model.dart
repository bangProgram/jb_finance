class LoginModel {
  final String userId;
  final String password;

  LoginModel({required this.userId, required this.password});

  LoginModel.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        password = json['password'];

  LoginModel.empty()
      : userId = "",
        password = "";

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'password': password,
    };
  }
}
