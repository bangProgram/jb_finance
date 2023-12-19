class PlanDetailMemoModel {
  final String corpCode;
  final String corpName;
  final String stockCode;
  final String userId;
  final int seq;
  final String? gubn;
  final String memo;
  final int createDt;
  final int changeDt;

  PlanDetailMemoModel({
    required this.corpCode,
    required this.corpName,
    required this.stockCode,
    required this.userId,
    required this.seq,
    required this.gubn,
    required this.memo,
    required this.createDt,
    required this.changeDt,
  });

  PlanDetailMemoModel.fromJson(Map<String, dynamic> json)
      : corpCode = json['corpCode'],
        corpName = json['corpName'],
        stockCode = json['stockCode'],
        userId = json['userId'],
        seq = json['seq'],
        gubn = json['gubn'],
        memo = json['memo'],
        createDt = json['createDt'],
        changeDt = json['changeDt'];

  PlanDetailMemoModel.empty()
      : corpCode = "",
        corpName = "",
        stockCode = "",
        userId = "",
        seq = 0,
        gubn = null,
        memo = "",
        createDt = 0,
        changeDt = 0;

  Map<String, dynamic> toJson() {
    return {
      'corpCode': corpCode,
      'corpName': corpName,
      'stockCode': stockCode,
      'userId': userId,
      'seq': seq,
      'gubn': gubn,
      'memo': memo,
      'createDt': createDt,
      'changeDt': changeDt,
    };
  }
}
