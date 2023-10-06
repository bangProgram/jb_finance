class SignupModel {
  final String userId;
  final String password;
  final String userNick;
  final String email;

  SignupModel(
      {required this.userId,
      required this.password,
      required this.userNick,
      required this.email});

  SignupModel.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        password = json['password'],
        userNick = json['userNick'],
        email = json['email'];

  SignupModel.empty()
      : userId = "",
        password = "",
        userNick = "",
        email = "";

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'password': password,
      'userNick': userNick,
      'email': email,
    };
  }
}
