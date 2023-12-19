class PortfolioCorpModel {
  final String corpCode;
  final String userId;
  final String corpName;
  final String stockCode;
  final String gubn;
  final String createId;
  final int createDt;
  final String changeId;
  final int changeDt;
  final String memo;
  final String investOpinion;
  final String indutyName;
  final int holdQuantity;
  final int avrPrice;
  final int estimateEps;
  final double avgRevenueGrowth;
  final double avgOperatGrowth;
  final double avgProfitGrowth;
  final int befClsPrice;
  final int investOpinionAmount;
  final int sharesAmount;
  final double currentPer;
  final double avrPer;
  final double estimateCagr;
  final int returnAmount;

  PortfolioCorpModel({
    required this.corpCode,
    required this.userId,
    required this.corpName,
    required this.stockCode,
    required this.gubn,
    required this.createId,
    required this.createDt,
    required this.changeId,
    required this.changeDt,
    required this.memo,
    required this.investOpinion,
    required this.indutyName,
    required this.holdQuantity,
    required this.avrPrice,
    required this.estimateEps,
    required this.avgRevenueGrowth,
    required this.avgOperatGrowth,
    required this.avgProfitGrowth,
    required this.befClsPrice,
    required this.investOpinionAmount,
    required this.sharesAmount,
    required this.currentPer,
    required this.avrPer,
    required this.estimateCagr,
    required this.returnAmount,
  });

  PortfolioCorpModel.fromJson(Map<String, dynamic> json)
      : corpCode = json['corpCode'],
        userId = json['userId'],
        corpName = json['corpName'],
        stockCode = json['stockCode'],
        gubn = json['gubn'],
        createId = json['createId'],
        createDt = json['createDt'],
        changeId = json['changeId'],
        changeDt = json['changeDt'],
        memo = json['memo'],
        investOpinion = json['investOpinion'],
        indutyName = json['indutyName'],
        holdQuantity = json['holdQuantity'],
        avrPrice = json['avrPrice'],
        estimateEps = json['estimateEps'],
        avgRevenueGrowth = json['avgRevenueGrowth'],
        avgOperatGrowth = json['avgOperatGrowth'],
        avgProfitGrowth = json['avgProfitGrowth'],
        befClsPrice = json['befClsPrice'],
        investOpinionAmount = json['investOpinionAmount'],
        sharesAmount = json['sharesAmount'],
        currentPer = json['currentPer'],
        avrPer = json['avrPer'],
        estimateCagr = json['estimateCagr'],
        returnAmount = json['returnAmount'];

  PortfolioCorpModel.empty()
      : corpCode = "",
        userId = "",
        corpName = "",
        stockCode = "",
        gubn = "",
        createId = "",
        createDt = 0,
        changeId = "",
        changeDt = 0,
        memo = "",
        investOpinion = "",
        indutyName = "",
        holdQuantity = 0,
        avrPrice = 0,
        estimateEps = 0,
        avgRevenueGrowth = 0,
        avgOperatGrowth = 0,
        avgProfitGrowth = 0,
        befClsPrice = 0,
        investOpinionAmount = 0,
        sharesAmount = 0,
        currentPer = 0,
        avrPer = 0,
        estimateCagr = 0,
        returnAmount = 0;

  Map<String, dynamic> toJson() {
    return {
      'corpCode': corpCode,
      'userId': userId,
      'corpName': corpName,
      'stockCode': stockCode,
      'gubn': gubn,
      'createId': createId,
      'createDt': createDt,
      'changeId': changeId,
      'changeDt': changeDt,
      'memo': memo,
      'investOpinion': investOpinion,
      'indutyName': indutyName,
      'holdQuantity': holdQuantity,
      'avrPrice': avrPrice,
      'estimateEps': estimateEps,
      'avgRevenueGrowth': avgRevenueGrowth,
      'avgOperatGrowth': avgOperatGrowth,
      'avgProfitGrowth': avgProfitGrowth,
      'befClsPrice': befClsPrice,
      'investOpinionAmount': investOpinionAmount,
      'sharesAmount': sharesAmount,
      'currentPer': currentPer,
      'avrPer': avrPer,
      'estimateCagr': estimateCagr,
      'returnAmount      ': returnAmount,
    };
  }
}
