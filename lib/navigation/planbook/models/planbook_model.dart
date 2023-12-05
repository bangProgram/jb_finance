class PlanbookModel {
  final String corpCode;
  final String corpName;
  final String stockCode;
  final String userId;
  final String createId;
  final String createDt;
  final String changeId;
  final String changeDt;
  final int befClsPrice;
  final String? memo;
  final String? investOpinion;
  final String? opinionAmount1;
  final String? opinionAmount2;
  final String? opinionAmount3;
  final String? opinionAmount4;
  final String? opinionAmount5;
  final String? periodGubn;
  final String periodNm;
  final String? estimateEps;
  final String? estimatePer;
  final String? estimateCagr;

  PlanbookModel({
    required this.corpCode,
    required this.corpName,
    required this.stockCode,
    required this.userId,
    required this.createId,
    required this.createDt,
    required this.changeId,
    required this.changeDt,
    required this.befClsPrice,
    required this.memo,
    required this.investOpinion,
    required this.opinionAmount1,
    required this.opinionAmount2,
    required this.opinionAmount3,
    required this.opinionAmount4,
    required this.opinionAmount5,
    required this.periodGubn,
    required this.periodNm,
    required this.estimateEps,
    required this.estimatePer,
    required this.estimateCagr,
  });

  PlanbookModel.fromJson(Map<String, dynamic> json)
      : corpCode = json['corpCode'],
        corpName = json['corpName'],
        stockCode = json['stockCode'],
        userId = json['userId'],
        createId = json['createId'],
        createDt = json['createDt'],
        changeId = json['changeId'],
        changeDt = json['changeDt'],
        befClsPrice = json['befClsPrice'],
        memo = json['memo'],
        investOpinion = json['investOpinion'],
        opinionAmount1 = json['opinionAmount1'],
        opinionAmount2 = json['opinionAmount2'],
        opinionAmount3 = json['opinionAmount3'],
        opinionAmount4 = json['opinionAmount4'],
        opinionAmount5 = json['opinionAmount5'],
        periodGubn = json['periodGubn'],
        periodNm = json['periodNm'],
        estimateEps = json['estimateEps'],
        estimatePer = json['estimatePer'],
        estimateCagr = json['estimateCagr'];

  PlanbookModel.empty()
      : corpCode = "",
        corpName = "",
        stockCode = "",
        userId = "",
        createId = "",
        createDt = "",
        changeId = "",
        changeDt = "",
        befClsPrice = 0,
        memo = null,
        investOpinion = null,
        opinionAmount1 = null,
        opinionAmount2 = null,
        opinionAmount3 = null,
        opinionAmount4 = null,
        opinionAmount5 = null,
        periodGubn = null,
        periodNm = "미정",
        estimateEps = null,
        estimatePer = null,
        estimateCagr = null;

  Map<String, dynamic> toJson() {
    return {
      'corpCode': corpCode,
      'corpName': corpName,
      'stockCode': stockCode,
      'userId': userId,
      'createId': createId,
      'createDt': createDt,
      'changeId': changeId,
      'changeDt': changeDt,
      'befClsPrice': befClsPrice,
      'memo': memo,
      'investOpinion': investOpinion,
      'opinionAmount1': opinionAmount1,
      'opinionAmount2': opinionAmount2,
      'opinionAmount3': opinionAmount3,
      'opinionAmount4': opinionAmount4,
      'opinionAmount5': opinionAmount5,
      'periodGubn': periodGubn,
      'periodNm': periodNm,
      'estimateEps': estimateEps,
      'estimatePer': estimatePer,
      'estimateCagr': estimateCagr,
    };
  }
}
