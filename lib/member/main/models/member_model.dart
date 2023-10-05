class MemberModel {
  final String user_id;
  final String password;
  final String user_name;
  final String user_nick;
  final String certified;
  final String user_group;
  final String group_author;
  final String use_at;
  final String phone_number;
  final String email;
  final String session_id;
  final DateTime pw_change_date;
  final DateTime create_date;
  final DateTime change_date;
  final DateTime error_time;
  final int error_count;
  final String file_id;

  MemberModel({
    required this.user_id,
    required this.password,
    required this.user_name,
    required this.user_nick,
    required this.certified,
    required this.user_group,
    required this.group_author,
    required this.use_at,
    required this.phone_number,
    required this.email,
    required this.session_id,
    required this.pw_change_date,
    required this.create_date,
    required this.change_date,
    required this.error_time,
    required this.error_count,
    required this.file_id,
  });

  MemberModel.empty()
      : user_id = "",
        password = "",
        user_name = "",
        user_nick = "",
        certified = "",
        user_group = "",
        group_author = "",
        use_at = "",
        phone_number = "",
        email = "",
        session_id = "",
        pw_change_date = DateTime.now(),
        create_date = DateTime.now(),
        change_date = DateTime.now(),
        error_time = DateTime.now(),
        error_count = 0,
        file_id = "";

  MemberModel.fromJson(Map<String, dynamic> json)
      : user_id = json["user_id"],
        password = json["password"],
        user_name = json["user_name"],
        user_nick = json["user_nick"],
        certified = json["certified"],
        user_group = json["user_group"],
        group_author = json["group_author"],
        use_at = json["use_at"],
        phone_number = json["phone_number"],
        email = json["email"],
        session_id = json["session_id"],
        pw_change_date = json["pw_change_date"],
        create_date = json["create_date"],
        change_date = json["change_date"],
        error_time = json["error_time"],
        error_count = json["error_count"],
        file_id = json["file_id"];

  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'password': password,
      'user_name': user_name,
      'user_nick': user_nick,
      'certified': certified,
      'user_group': user_group,
      'group_author': group_author,
      'use_at': use_at,
      'phone_number': phone_number,
      'email': email,
      'session_id': session_id,
      'pw_change_date': pw_change_date,
      'create_date': create_date,
      'change_date': change_date,
      'error_time': error_time,
      'error_count': error_count,
      'file_id': file_id,
    };
  }
}
