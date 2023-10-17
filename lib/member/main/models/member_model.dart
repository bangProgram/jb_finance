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
  final String sessionId;
  final int pwChangeDate;
  final int createDate;
  final int changeDate;
  final int errorTime;
  final int errorCount;
  final String fileName;
  final String platform;
  final String avatarUrl;

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
    required this.sessionId,
    required this.pwChangeDate,
    required this.createDate,
    required this.changeDate,
    required this.errorTime,
    required this.errorCount,
    required this.fileName,
    required this.platform,
    required this.avatarUrl,
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
        sessionId = "",
        pwChangeDate = 0,
        createDate = 0,
        changeDate = 0,
        errorTime = 0,
        errorCount = 0,
        fileName = "",
        platform = "",
        avatarUrl = "";

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
        sessionId = json["sessionId"] ?? "",
        pwChangeDate = json["pwChangeDate"] ?? 0,
        createDate = json["createDate"] ?? 0,
        changeDate = json["changeDate"] ?? 0,
        errorTime = json["errorTime"] ?? 0,
        errorCount = json["errorCount"] ?? 0,
        fileName = json["fileName"] ?? "",
        platform = json["platform"] ?? "",
        avatarUrl = json["avatarUrl"] ?? "";

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
      'sessionId': sessionId,
      'pwChangeDate': pwChangeDate,
      'createDate': createDate,
      'changeDate': changeDate,
      'errorTime': errorTime,
      'errorCount': errorCount,
      'fileName': fileName,
      'platform': platform,
      'avatarUrl': avatarUrl,
    };
  }

  MemberModel copyWith({
    String? userId,
    String? password,
    String? userName,
    String? userNick,
    String? certified,
    String? userGroup,
    String? groupAuthor,
    String? useAt,
    String? phoneNumber,
    String? sessionId,
    int? pwChangeDate,
    int? createDate,
    int? changeDate,
    int? errorTime,
    int? errorCount,
    String? fileName,
    String? platform,
    String? avatarUrl,
  }) {
    return MemberModel(
      userId: userId ?? this.userId,
      password: password ?? this.password,
      userName: userName ?? this.userName,
      userNick: userNick ?? this.userNick,
      certified: certified ?? this.certified,
      userGroup: userGroup ?? this.userGroup,
      groupAuthor: groupAuthor ?? this.groupAuthor,
      useAt: useAt ?? this.useAt,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      sessionId: sessionId ?? this.sessionId,
      pwChangeDate: pwChangeDate ?? this.pwChangeDate,
      createDate: createDate ?? this.createDate,
      changeDate: changeDate ?? this.changeDate,
      errorTime: errorTime ?? this.errorTime,
      errorCount: errorCount ?? this.errorCount,
      fileName: fileName ?? this.fileName,
      platform: platform ?? this.platform,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
