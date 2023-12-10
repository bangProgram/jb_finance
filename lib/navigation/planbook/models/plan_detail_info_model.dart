import 'dart:ffi';

class PlanDetailInfoModel {
  final String corpCode;
  final String corpName;
  final String stockCode;
  final String userId;
  final String createId;
  final String createDt;
  final String changeId;
  final int changeDt;
  final int befClsPrice;
  final int sharesAmount;
  final int marketCapital;
  final int tradeVolume;
  final int tradeAmount;
  final int compareAmount;
  final String fluctuateRate;
  final int stPrice;
  final int hgPrice;
  final int lwPrice;
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

  final String? avgGrowthArith1;
  final String? avgGrowthArith2;
  final String? avgGrowthArith3;
  final String? avgGrowthArith4;
  final double? avgGrowthGeo1;
  final double? avgGrowthGeo2;
  final double? avgGrowthGeo3;
  final double? avgGrowthGeo4;
  final String? geoStYear;
  final String? geoEdYear;

  PlanDetailInfoModel({
    required this.corpCode,
    required this.corpName,
    required this.stockCode,
    required this.userId,
    required this.createId,
    required this.createDt,
    required this.changeId,
    required this.changeDt,
    required this.befClsPrice,
    required this.sharesAmount,
    required this.marketCapital,
    required this.tradeVolume,
    required this.tradeAmount,
    required this.compareAmount,
    required this.fluctuateRate,
    required this.stPrice,
    required this.hgPrice,
    required this.lwPrice,
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
    required this.avgGrowthArith1,
    required this.avgGrowthArith2,
    required this.avgGrowthArith3,
    required this.avgGrowthArith4,
    required this.avgGrowthGeo1,
    required this.avgGrowthGeo2,
    required this.avgGrowthGeo3,
    required this.avgGrowthGeo4,
    required this.geoStYear,
    required this.geoEdYear,
  });

  PlanDetailInfoModel.fromJson(Map<String, dynamic> json)
      : corpCode = json['corpCode'],
        corpName = json['corpName'],
        stockCode = json['stockCode'],
        userId = json['userId'],
        createId = json['createId'],
        createDt = json['createDt'],
        changeId = json['changeId'],
        changeDt = json['changeDt'],
        befClsPrice = json['befClsPrice'],
        sharesAmount = json['sharesAmount'],
        marketCapital = json['marketCapital'],
        tradeVolume = json['tradeVolume'],
        tradeAmount = json['tradeAmount'],
        compareAmount = json['compareAmount'],
        fluctuateRate = json['fluctuateRate'],
        stPrice = json['stPrice'],
        hgPrice = json['hgPrice'],
        lwPrice = json['lwPrice'],
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
        estimateCagr = json['estimateCagr'],
        avgGrowthArith1 = json['avgGrowthArith1'],
        avgGrowthArith2 = json['avgGrowthArith2'],
        avgGrowthArith3 = json['avgGrowthArith3'],
        avgGrowthArith4 = json['avgGrowthArith4'],
        avgGrowthGeo1 = json['avgGrowthGeo1'],
        avgGrowthGeo2 = json['avgGrowthGeo2'],
        avgGrowthGeo3 = json['avgGrowthGeo3'],
        avgGrowthGeo4 = json['avgGrowthGeo4'],
        geoStYear = json['geoStYear'],
        geoEdYear = json['geoEdYear'];

  PlanDetailInfoModel.empty()
      : corpCode = "",
        corpName = "",
        stockCode = "",
        userId = "",
        createId = "",
        createDt = "",
        changeId = "",
        changeDt = 0,
        befClsPrice = 0,
        sharesAmount = 0,
        marketCapital = 0,
        tradeVolume = 0,
        tradeAmount = 0,
        compareAmount = 0,
        fluctuateRate = "",
        stPrice = 0,
        hgPrice = 0,
        lwPrice = 0,
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
        estimateCagr = null,
        avgGrowthArith1 = null,
        avgGrowthArith2 = null,
        avgGrowthArith3 = null,
        avgGrowthArith4 = null,
        avgGrowthGeo1 = null,
        avgGrowthGeo2 = null,
        avgGrowthGeo3 = null,
        avgGrowthGeo4 = null,
        geoStYear = null,
        geoEdYear = null;

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
      'sharesAmount': sharesAmount,
      'marketCapital': marketCapital,
      'tradeVolume': tradeVolume,
      'tradeAmount': tradeAmount,
      'compareAmount': compareAmount,
      'fluctuateRate': fluctuateRate,
      'stPrice': stPrice,
      'hgPrice': hgPrice,
      'lwPrice': lwPrice,
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
      'avgGrowthArith1': avgGrowthArith1,
      'avgGrowthArith2': avgGrowthArith2,
      'avgGrowthArith3': avgGrowthArith3,
      'avgGrowthArith4': avgGrowthArith4,
      'avgGrowthGeo1': avgGrowthGeo1,
      'avgGrowthGeo2': avgGrowthGeo2,
      'avgGrowthGeo3': avgGrowthGeo3,
      'avgGrowthGeo4': avgGrowthGeo4,
      'geoStYear': geoStYear,
      'geoEdYear': geoEdYear,
    };
  }
}
