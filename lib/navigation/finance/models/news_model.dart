class NewsModel {
  final String id;
  final String officeId;
  final String articleId;
  final String officeName;
  final String datetime;
  final int type;
  final String title;
  final String body;
  final int photoType;
  final String imageOriginLink;
  final String titleFull;

  NewsModel({
    required this.id,
    required this.officeId,
    required this.articleId,
    required this.officeName,
    required this.datetime,
    required this.type,
    required this.title,
    required this.body,
    required this.photoType,
    required this.imageOriginLink,
    required this.titleFull,
  });

  NewsModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        officeId = json['officeId'],
        articleId = json['articleId'],
        officeName = json['officeName'],
        datetime = json['datetime'],
        type = json['type'],
        title = json['title'],
        body = json['body'],
        photoType = json['photoType'],
        imageOriginLink = json['imageOriginLink'],
        titleFull = json['titleFull'];

  NewsModel.empty()
      : id = "",
        officeId = "",
        articleId = "",
        officeName = "",
        datetime = "",
        type = 0,
        title = "",
        body = "",
        photoType = 0,
        imageOriginLink = "",
        titleFull = "";

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'officeId': officeId,
      'articleId': articleId,
      'officeName': officeName,
      'datetime': datetime,
      'type': type,
      'title': title,
      'body': body,
      'photoType': photoType,
      'imageOriginLink': imageOriginLink,
      'titleFull': titleFull,
    };
  }
}
