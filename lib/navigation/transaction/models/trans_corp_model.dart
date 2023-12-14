class TransCorpModel {
  final String corpCode;
  final String userId;
  final String corpName;
  final String stockCode;
  final String createId;
  final String createDt;
  final String changeId;
  final String changeDt;
  final int holdQuantity;
  final int avgPrice;
  final int befClsPrice;
  final int valPrice;

  TransCorpModel({
    required this.corpCode,
    required this.userId,
    required this.corpName,
    required this.stockCode,
    required this.createId,
    required this.createDt,
    required this.changeId,
    required this.changeDt,
    required this.holdQuantity,
    required this.avgPrice,
    required this.befClsPrice,
    required this.valPrice,
  });

  TransCorpModel.fromJson(Map<String, dynamic> json)
      : corpCode = json['corpCode'],
        userId = json['userId'],
        corpName = json['corpName'],
        stockCode = json['stockCode'],
        createId = json['createId'],
        createDt = json['createDt'],
        changeId = json['changeId'],
        changeDt = json['changeDt'],
        holdQuantity = json['holdQuantity'],
        avgPrice = json['avgPrice'],
        befClsPrice = json['befClsPrice'],
        valPrice = json['valPrice'];

  TransCorpModel.empty()
      : corpCode = "",
        userId = "",
        corpName = "",
        stockCode = "",
        createId = "",
        createDt = "",
        changeId = "",
        changeDt = "",
        holdQuantity = 0,
        avgPrice = 0,
        befClsPrice = 0,
        valPrice = 0;

  Map<String, dynamic> toJson() {
    return {
      'corpCode': corpCode,
      'userId': userId,
      'corpName': corpName,
      'stockCode': stockCode,
      'createId': createId,
      'createDt': createDt,
      'changeId': changeId,
      'changeDt': changeDt,
      'holdQuantity': holdQuantity,
      'avgPrice': avgPrice,
      'befClsPrice': befClsPrice,
      'valPrice': valPrice,
    };
  }
}
