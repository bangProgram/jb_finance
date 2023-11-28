class CorporationModel {
  final String corpCode;
  final String corpName;
  final int? curAmount1;
  final int? befAmount1;
  final dynamic avgAmount1;
  final int? curAmount2;
  final int? befAmount2;
  final dynamic avgAmount2;
  final int? curAmount3;
  final int? befAmount3;
  final dynamic avgAmount3;
  final int? curAmount4;
  final int? befAmount4;
  final dynamic avgAmount4;
  final String? isInterest;
  final String? isPortfolio;
  final String? stYear;
  final String? edYear;
  final String? stHalf;
  final String? edHalf;

  CorporationModel({
    required this.corpCode,
    required this.corpName,
    this.curAmount1,
    this.befAmount1,
    this.avgAmount1,
    this.curAmount2,
    this.befAmount2,
    this.avgAmount2,
    this.curAmount3,
    this.befAmount3,
    this.avgAmount3,
    this.curAmount4,
    this.befAmount4,
    this.avgAmount4,
    this.isInterest,
    this.isPortfolio,
    this.stYear,
    this.edYear,
    this.stHalf,
    this.edHalf,
  });

  CorporationModel.fromJson(Map<String, dynamic> json)
      : corpCode = json['corpCode'],
        corpName = json['corpName'],
        curAmount1 = json['curAmount1'],
        befAmount1 = json['befAmount1'],
        avgAmount1 = json['avgAmount1'],
        curAmount2 = json['curAmount2'],
        befAmount2 = json['befAmount2'],
        avgAmount2 = json['avgAmount2'],
        curAmount3 = json['curAmount3'],
        befAmount3 = json['befAmount3'],
        avgAmount3 = json['avgAmount3'],
        curAmount4 = json['curAmount4'],
        befAmount4 = json['befAmount4'],
        avgAmount4 = json['avgAmount4'],
        isInterest = json['isInterest'],
        isPortfolio = json['isPortfolio'],
        stYear = json['stYear'],
        edYear = json['edYear'],
        stHalf = json['stHalf'],
        edHalf = json['edHalf'];

  CorporationModel.empty()
      : corpCode = "",
        corpName = "",
        curAmount1 = 0,
        befAmount1 = 0,
        avgAmount1 = 0,
        curAmount2 = 0,
        befAmount2 = 0,
        avgAmount2 = 0,
        curAmount3 = 0,
        befAmount3 = 0,
        avgAmount3 = 0,
        curAmount4 = 0,
        befAmount4 = 0,
        avgAmount4 = 0,
        isInterest = "",
        isPortfolio = "",
        stYear = "",
        edYear = "",
        stHalf = "",
        edHalf = "";

  Map<String, dynamic> toJson() {
    return {
      'corpCode': corpCode,
      'corpName': corpName,
      'curAmount1': curAmount1,
      'befAmount1': befAmount1,
      'avgAmount1': avgAmount1,
      'curAmount2': curAmount2,
      'befAmount2': befAmount2,
      'avgAmount2': avgAmount2,
      'curAmount3': curAmount3,
      'befAmount3': befAmount3,
      'avgAmount3': avgAmount3,
      'curAmount4': curAmount4,
      'befAmount4': befAmount4,
      'avgAmount4': avgAmount4,
      'isInterest': isInterest,
      'isPortfolio': isPortfolio,
      'stYear': stYear,
      'edYear': edYear,
      'stHalf': stHalf,
      'edHalf': edHalf,
    };
  }
}
