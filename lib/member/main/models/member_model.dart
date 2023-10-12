class MemberModel {
  final String userId;
  final String password;
  final String userName;
  final String userNick;
  final String certified;
  final String userGroup;
  final String groupAuthor;
  final String useAt;
  final String phoneNumber;
  final String email;
  final String sessionId;
  final int pwChangeDate;
  final int createDate;
  final int changeDate;
  final int errorTime;
  final int errorCount;
  final String fileName;

  MemberModel({
    required this.userId,
    required this.password,
    required this.userName,
    required this.userNick,
    required this.certified,
    required this.userGroup,
    required this.groupAuthor,
    required this.useAt,
    required this.phoneNumber,
    required this.email,
    required this.sessionId,
    required this.pwChangeDate,
    required this.createDate,
    required this.changeDate,
    required this.errorTime,
    required this.errorCount,
    required this.fileName,
  });

  MemberModel.empty()
      : userId = "",
        password = "",
        userName = "",
        userNick = "",
        certified = "",
        userGroup = "",
        groupAuthor = "",
        useAt = "",
        phoneNumber = "",
        email = "",
        sessionId = "",
        pwChangeDate = 0,
        createDate = 0,
        changeDate = 0,
        errorTime = 0,
        errorCount = 0,
        fileName = "";

  MemberModel.fromJson(Map<String, dynamic> json)
      : userId = json["userId"],
        password = json["password"],
        userName = json["userName"] ?? "",
        userNick = json["userNick"] ?? "",
        certified = json["certified"] ?? "",
        userGroup = json["userGroup"] ?? "",
        groupAuthor = json["groupAuthor"] ?? "",
        useAt = json["useAt"] ?? "",
        phoneNumber = json["phoneNumber"] ?? "",
        email = json["email"] ?? "",
        sessionId = json["sessionId"] ?? "",
        pwChangeDate = json["pwChangeDate"] ?? 0,
        createDate = json["createDate"] ?? 0,
        changeDate = json["changeDate"] ?? 0,
        errorTime = json["errorTime"] ?? 0,
        errorCount = json["errorCount"] ?? 0,
        fileName = json["fileName"] ?? "";

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'password': password,
      'userName': userName,
      'userNick': userNick,
      'certified': certified,
      'userGroup': userGroup,
      'groupAuthor': groupAuthor,
      'useAt': useAt,
      'phoneNumber': phoneNumber,
      'email': email,
      'sessionId': sessionId,
      'pwChangeDate': pwChangeDate,
      'createDate': createDate,
      'changeDate': changeDate,
      'errorTime': errorTime,
      'errorCount': errorCount,
      'fileName': fileName,
    };
  }
}
